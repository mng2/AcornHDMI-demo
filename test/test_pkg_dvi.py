# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# adapted from cocotb/examples/matrix_multiplier/tests/

import math
import os
from random import getrandbits
from typing import Dict, List, Any

import cocotb
from cocotb.binary import BinaryValue
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from cocotb.queue import Queue
from cocotb.handle import SimHandleBase

NUM_SAMPLES = int(os.environ.get('NUM_SAMPLES', 3000))
DATA_WIDTH = 8 # fixed size

class DataValidMonitor:
    """
    Reusable Monitor of one-way control flow (data/valid) streaming data interface

    Args
        clk: clock signal
        valid: control signal noting a transaction occured
        datas: named handles to be sampled when transaction occurs
    """

    def __init__(self, clk: SimHandleBase, datas: Dict[str, SimHandleBase], valid: SimHandleBase):
        self.values = Queue[Dict[str, int]]()
        self._clk = clk
        self._datas = datas
        self._valid = valid
        self._coro = None

    def start(self) -> None:
        """Start monitor"""
        if self._coro is not None:
            raise RuntimeError("Monitor already started")
        self._coro = cocotb.start_soon(self._run())

    def stop(self) -> None:
        """Stop monitor"""
        if self._coro is None:
            raise RuntimeError("Monitor never started")
        self._coro.kill()
        self._coro = None

    async def _run(self) -> None:
        while True:
            await RisingEdge(self._clk)
            if self._valid.value.binstr != '1':
                await RisingEdge(self._valid)
                continue
            self.values.put_nowait(self._sample())

    def _sample(self) -> Dict[str, Any]:
        """
        Samples the data signals and builds a transaction object

        Return value is what is stored in queue. Meant to be overriden by the user.
        """
        return {name: handle.value for name, handle in self._datas.items()}


class TMDS_Roundtrip_Tester:
    """
    Reusable checker of a matrix_multiplier instance

    Args
        matrix_multiplier_entity: handle to an instance of matrix_multiplier
    """

    def __init__(self, dut_entity: SimHandleBase):
        self.dut = dut_entity

        self.input_mon = DataValidMonitor(
            clk=self.dut.clk,
            valid=self.dut.validin,
            datas=dict( A=self.dut.din)
        )

        self.output_mon = DataValidMonitor(
            clk=self.dut.clk,
            valid=self.dut.validout,
            datas=dict(Y=self.dut.dout)
        )

        self._checker = None

    def start(self) -> None:
        """Starts monitors, model, and checker coroutine"""
        if self._checker is not None:
            raise RuntimeError("Monitor already started")
        self.input_mon.start()
        self.output_mon.start()
        self._checker = cocotb.start_soon(self._check())

    def stop(self) -> None:
        """Stops everything"""
        if self._checker is None:
            raise RuntimeError("Monitor never started")
        self.input_mon.stop()
        self.output_mon.stop()
        self._checker.kill()
        self._checker = None

    async def _check(self) -> None:
        while True:
            actual = await self.output_mon.values.get()
            expected_inputs = await self.input_mon.values.get()
            assert actual['Y'] == expected_inputs['A']

@cocotb.test(
    expect_error=IndexError if cocotb.SIM_NAME.lower().startswith("ghdl") else ()
)
async def test_multiply(dut):
    """Test multiplication of many matrices."""

    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())
    tester = TMDS_Roundtrip_Tester(dut)

    dut._log.info("Initialize and reset model")

    # Initial values
    dut.validin.value = 0
    dut.din.value = 0

    # Reset DUT
    dut.rst.value = 1
    for _ in range(3):
        await RisingEdge(dut.clk)
    dut.rst.value = 0

    # start tester after reset so we know it's in a good state
    tester.start()

    dut._log.info("Test operations")

    # Do operations
    for i,A in enumerate( gen_a() ):
        await RisingEdge(dut.clk)
        dut.din.value = A
        dut.validin.value = 1

        await RisingEdge(dut.clk)
        dut.validin.value = 0

        if i % 100 == 0:
            dut._log.info(f"{i} / {NUM_SAMPLES}")

    await RisingEdge(dut.clk)

def gen_a(num_samples=NUM_SAMPLES, func=getrandbits):
    """Generate random bytes for A"""
    for _ in range(num_samples):
        yield func(DATA_WIDTH)

