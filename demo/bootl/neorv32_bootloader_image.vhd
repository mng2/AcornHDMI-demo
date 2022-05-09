-- The NEORV32 RISC-V Processor, https://github.com/stnolting/neorv32
-- Auto-generated memory init file (for BOOTLOADER) from source file <bootl/main.bin>
-- Size: 2572 bytes

library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

package neorv32_bootloader_image is

  constant bootloader_init_image : mem32_t := (
    00000000 => x"00000037",
    00000001 => x"80010117",
    00000002 => x"1f810113",
    00000003 => x"80010197",
    00000004 => x"7f418193",
    00000005 => x"00000517",
    00000006 => x"0d450513",
    00000007 => x"30551073",
    00000008 => x"34151073",
    00000009 => x"30001073",
    00000010 => x"30401073",
    00000011 => x"30601073",
    00000012 => x"ffa00593",
    00000013 => x"32059073",
    00000014 => x"b0001073",
    00000015 => x"b8001073",
    00000016 => x"b0201073",
    00000017 => x"b8201073",
    00000018 => x"00000093",
    00000019 => x"00000213",
    00000020 => x"00000293",
    00000021 => x"00000313",
    00000022 => x"00000393",
    00000023 => x"00000713",
    00000024 => x"00000793",
    00000025 => x"00010417",
    00000026 => x"d9c40413",
    00000027 => x"00010497",
    00000028 => x"f9448493",
    00000029 => x"00042023",
    00000030 => x"00440413",
    00000031 => x"fe941ce3",
    00000032 => x"80010597",
    00000033 => x"f8058593",
    00000034 => x"80818613",
    00000035 => x"00c5d863",
    00000036 => x"00058023",
    00000037 => x"00158593",
    00000038 => x"ff5ff06f",
    00000039 => x"00001597",
    00000040 => x"97058593",
    00000041 => x"80010617",
    00000042 => x"f5c60613",
    00000043 => x"80010697",
    00000044 => x"f5468693",
    00000045 => x"00d65c63",
    00000046 => x"00058703",
    00000047 => x"00e60023",
    00000048 => x"00158593",
    00000049 => x"00160613",
    00000050 => x"fedff06f",
    00000051 => x"00000513",
    00000052 => x"00000593",
    00000053 => x"060000ef",
    00000054 => x"34051073",
    00000055 => x"30047073",
    00000056 => x"10500073",
    00000057 => x"ffdff06f",
    00000058 => x"ff810113",
    00000059 => x"00812023",
    00000060 => x"00912223",
    00000061 => x"34202473",
    00000062 => x"02044663",
    00000063 => x"34102473",
    00000064 => x"00041483",
    00000065 => x"0034f493",
    00000066 => x"00240413",
    00000067 => x"34141073",
    00000068 => x"00300413",
    00000069 => x"00941863",
    00000070 => x"34102473",
    00000071 => x"00240413",
    00000072 => x"34141073",
    00000073 => x"00012403",
    00000074 => x"00412483",
    00000075 => x"00810113",
    00000076 => x"30200073",
    00000077 => x"fd010113",
    00000078 => x"02912223",
    00000079 => x"800004b7",
    00000080 => x"00048793",
    00000081 => x"02112623",
    00000082 => x"02812423",
    00000083 => x"03212023",
    00000084 => x"01312e23",
    00000085 => x"01412c23",
    00000086 => x"01512a23",
    00000087 => x"01612823",
    00000088 => x"01712623",
    00000089 => x"01812423",
    00000090 => x"01912223",
    00000091 => x"0007a023",
    00000092 => x"8001a223",
    00000093 => x"ffff07b7",
    00000094 => x"59478793",
    00000095 => x"30579073",
    00000096 => x"6a0000ef",
    00000097 => x"00048493",
    00000098 => x"00050863",
    00000099 => x"00100513",
    00000100 => x"00000593",
    00000101 => x"6cc000ef",
    00000102 => x"00005537",
    00000103 => x"00000613",
    00000104 => x"00000593",
    00000105 => x"b0050513",
    00000106 => x"54c000ef",
    00000107 => x"6f0000ef",
    00000108 => x"02050663",
    00000109 => x"6bc000ef",
    00000110 => x"fe002783",
    00000111 => x"0027d793",
    00000112 => x"00a78533",
    00000113 => x"00f537b3",
    00000114 => x"00b785b3",
    00000115 => x"6e0000ef",
    00000116 => x"08000793",
    00000117 => x"30479073",
    00000118 => x"30046073",
    00000119 => x"ffff1537",
    00000120 => x"94450513",
    00000121 => x"5e4000ef",
    00000122 => x"f1302573",
    00000123 => x"338000ef",
    00000124 => x"ffff1537",
    00000125 => x"97c50513",
    00000126 => x"5d0000ef",
    00000127 => x"fe002503",
    00000128 => x"324000ef",
    00000129 => x"ffff1537",
    00000130 => x"98450513",
    00000131 => x"5bc000ef",
    00000132 => x"30102573",
    00000133 => x"310000ef",
    00000134 => x"ffff1537",
    00000135 => x"98c50513",
    00000136 => x"5a8000ef",
    00000137 => x"fe402503",
    00000138 => x"ffff1437",
    00000139 => x"ffff19b7",
    00000140 => x"2f4000ef",
    00000141 => x"ffff1537",
    00000142 => x"99450513",
    00000143 => x"58c000ef",
    00000144 => x"fe802503",
    00000145 => x"ffff1a37",
    00000146 => x"07200a93",
    00000147 => x"2d8000ef",
    00000148 => x"ffff1537",
    00000149 => x"99c50513",
    00000150 => x"570000ef",
    00000151 => x"ff802503",
    00000152 => x"06800b13",
    00000153 => x"07500b93",
    00000154 => x"2bc000ef",
    00000155 => x"9a440513",
    00000156 => x"558000ef",
    00000157 => x"ff002503",
    00000158 => x"06500c13",
    00000159 => x"ffff1937",
    00000160 => x"2a4000ef",
    00000161 => x"ffff1537",
    00000162 => x"9b050513",
    00000163 => x"53c000ef",
    00000164 => x"ffc02503",
    00000165 => x"ffff1cb7",
    00000166 => x"28c000ef",
    00000167 => x"9a440513",
    00000168 => x"528000ef",
    00000169 => x"ff402503",
    00000170 => x"27c000ef",
    00000171 => x"ffff1537",
    00000172 => x"9b850513",
    00000173 => x"514000ef",
    00000174 => x"074000ef",
    00000175 => x"9bc98513",
    00000176 => x"508000ef",
    00000177 => x"4f4000ef",
    00000178 => x"00050413",
    00000179 => x"4b8000ef",
    00000180 => x"9c4a0513",
    00000181 => x"4f4000ef",
    00000182 => x"4c4000ef",
    00000183 => x"fe051ee3",
    00000184 => x"01541863",
    00000185 => x"ffff02b7",
    00000186 => x"00028067",
    00000187 => x"fd1ff06f",
    00000188 => x"01641663",
    00000189 => x"038000ef",
    00000190 => x"fc5ff06f",
    00000191 => x"01741663",
    00000192 => x"100000ef",
    00000193 => x"fb9ff06f",
    00000194 => x"01841e63",
    00000195 => x"0004a783",
    00000196 => x"00079863",
    00000197 => x"9c8c8513",
    00000198 => x"4b0000ef",
    00000199 => x"fa1ff06f",
    00000200 => x"018000ef",
    00000201 => x"9e490513",
    00000202 => x"ff1ff06f",
    00000203 => x"ffff1537",
    00000204 => x"8c450513",
    00000205 => x"4940006f",
    00000206 => x"ff010113",
    00000207 => x"00112623",
    00000208 => x"30047073",
    00000209 => x"ffff1537",
    00000210 => x"90050513",
    00000211 => x"47c000ef",
    00000212 => x"44c000ef",
    00000213 => x"fe051ee3",
    00000214 => x"ff002783",
    00000215 => x"00078067",
    00000216 => x"0000006f",
    00000217 => x"fe010113",
    00000218 => x"00812c23",
    00000219 => x"00912a23",
    00000220 => x"01212823",
    00000221 => x"00112e23",
    00000222 => x"00050493",
    00000223 => x"00000413",
    00000224 => x"00400913",
    00000225 => x"00049a63",
    00000226 => x"430000ef",
    00000227 => x"00c10793",
    00000228 => x"008787b3",
    00000229 => x"00a78023",
    00000230 => x"00140413",
    00000231 => x"ff2414e3",
    00000232 => x"01c12083",
    00000233 => x"01812403",
    00000234 => x"00c12503",
    00000235 => x"01412483",
    00000236 => x"01012903",
    00000237 => x"02010113",
    00000238 => x"00008067",
    00000239 => x"ff010113",
    00000240 => x"00812423",
    00000241 => x"00050413",
    00000242 => x"ffff1537",
    00000243 => x"91050513",
    00000244 => x"00112623",
    00000245 => x"3f4000ef",
    00000246 => x"03040513",
    00000247 => x"0ff57513",
    00000248 => x"3a4000ef",
    00000249 => x"30047073",
    00000250 => x"438000ef",
    00000251 => x"00050863",
    00000252 => x"00100513",
    00000253 => x"00000593",
    00000254 => x"468000ef",
    00000255 => x"0000006f",
    00000256 => x"fd010113",
    00000257 => x"01412c23",
    00000258 => x"02812423",
    00000259 => x"80418793",
    00000260 => x"02112623",
    00000261 => x"02912223",
    00000262 => x"03212023",
    00000263 => x"01312e23",
    00000264 => x"01512a23",
    00000265 => x"01612823",
    00000266 => x"01712623",
    00000267 => x"01812423",
    00000268 => x"00100713",
    00000269 => x"00e7a023",
    00000270 => x"00050413",
    00000271 => x"80418a13",
    00000272 => x"00051863",
    00000273 => x"ffff1537",
    00000274 => x"91c50513",
    00000275 => x"37c000ef",
    00000276 => x"080005b7",
    00000277 => x"00040513",
    00000278 => x"f0dff0ef",
    00000279 => x"4788d7b7",
    00000280 => x"afe78793",
    00000281 => x"00f50663",
    00000282 => x"00000513",
    00000283 => x"f51ff0ef",
    00000284 => x"080009b7",
    00000285 => x"00498593",
    00000286 => x"00040513",
    00000287 => x"ee9ff0ef",
    00000288 => x"00050a93",
    00000289 => x"00898593",
    00000290 => x"00040513",
    00000291 => x"ed9ff0ef",
    00000292 => x"ff002c03",
    00000293 => x"00050b13",
    00000294 => x"ffcafb93",
    00000295 => x"00000913",
    00000296 => x"00000493",
    00000297 => x"00c98993",
    00000298 => x"013905b3",
    00000299 => x"01791a63",
    00000300 => x"016484b3",
    00000301 => x"02048463",
    00000302 => x"00200513",
    00000303 => x"fb1ff06f",
    00000304 => x"00040513",
    00000305 => x"ea1ff0ef",
    00000306 => x"012c07b3",
    00000307 => x"00a484b3",
    00000308 => x"00a7a023",
    00000309 => x"00490913",
    00000310 => x"fd1ff06f",
    00000311 => x"ffff1537",
    00000312 => x"93c50513",
    00000313 => x"2e4000ef",
    00000314 => x"02c12083",
    00000315 => x"02812403",
    00000316 => x"800007b7",
    00000317 => x"0157a023",
    00000318 => x"000a2023",
    00000319 => x"02412483",
    00000320 => x"02012903",
    00000321 => x"01c12983",
    00000322 => x"01812a03",
    00000323 => x"01412a83",
    00000324 => x"01012b03",
    00000325 => x"00c12b83",
    00000326 => x"00812c03",
    00000327 => x"03010113",
    00000328 => x"00008067",
    00000329 => x"fe010113",
    00000330 => x"01212823",
    00000331 => x"00050913",
    00000332 => x"ffff1537",
    00000333 => x"00912a23",
    00000334 => x"94050513",
    00000335 => x"ffff14b7",
    00000336 => x"00812c23",
    00000337 => x"01312623",
    00000338 => x"00112e23",
    00000339 => x"01c00413",
    00000340 => x"278000ef",
    00000341 => x"9fc48493",
    00000342 => x"ffc00993",
    00000343 => x"008957b3",
    00000344 => x"00f7f793",
    00000345 => x"00f487b3",
    00000346 => x"0007c503",
    00000347 => x"ffc40413",
    00000348 => x"214000ef",
    00000349 => x"ff3414e3",
    00000350 => x"01c12083",
    00000351 => x"01812403",
    00000352 => x"01412483",
    00000353 => x"01012903",
    00000354 => x"00c12983",
    00000355 => x"02010113",
    00000356 => x"00008067",
    00000357 => x"fb010113",
    00000358 => x"04112623",
    00000359 => x"04512423",
    00000360 => x"04612223",
    00000361 => x"04712023",
    00000362 => x"02812e23",
    00000363 => x"02912c23",
    00000364 => x"02a12a23",
    00000365 => x"02b12823",
    00000366 => x"02c12623",
    00000367 => x"02d12423",
    00000368 => x"02e12223",
    00000369 => x"02f12023",
    00000370 => x"01012e23",
    00000371 => x"01112c23",
    00000372 => x"01c12a23",
    00000373 => x"01d12823",
    00000374 => x"01e12623",
    00000375 => x"01f12423",
    00000376 => x"342024f3",
    00000377 => x"800007b7",
    00000378 => x"00778793",
    00000379 => x"08f49463",
    00000380 => x"230000ef",
    00000381 => x"00050663",
    00000382 => x"00000513",
    00000383 => x"234000ef",
    00000384 => x"29c000ef",
    00000385 => x"02050063",
    00000386 => x"268000ef",
    00000387 => x"fe002783",
    00000388 => x"0027d793",
    00000389 => x"00a78533",
    00000390 => x"00f537b3",
    00000391 => x"00b785b3",
    00000392 => x"28c000ef",
    00000393 => x"03c12403",
    00000394 => x"04c12083",
    00000395 => x"04812283",
    00000396 => x"04412303",
    00000397 => x"04012383",
    00000398 => x"03812483",
    00000399 => x"03412503",
    00000400 => x"03012583",
    00000401 => x"02c12603",
    00000402 => x"02812683",
    00000403 => x"02412703",
    00000404 => x"02012783",
    00000405 => x"01c12803",
    00000406 => x"01812883",
    00000407 => x"01412e03",
    00000408 => x"01012e83",
    00000409 => x"00c12f03",
    00000410 => x"00812f83",
    00000411 => x"05010113",
    00000412 => x"30200073",
    00000413 => x"00700793",
    00000414 => x"00f49a63",
    00000415 => x"8041a783",
    00000416 => x"00078663",
    00000417 => x"00100513",
    00000418 => x"d35ff0ef",
    00000419 => x"34102473",
    00000420 => x"054000ef",
    00000421 => x"04050263",
    00000422 => x"ffff1537",
    00000423 => x"9f050513",
    00000424 => x"128000ef",
    00000425 => x"00048513",
    00000426 => x"e7dff0ef",
    00000427 => x"02000513",
    00000428 => x"0d4000ef",
    00000429 => x"00040513",
    00000430 => x"e6dff0ef",
    00000431 => x"02000513",
    00000432 => x"0c4000ef",
    00000433 => x"34302573",
    00000434 => x"e5dff0ef",
    00000435 => x"ffff1537",
    00000436 => x"9f850513",
    00000437 => x"0f4000ef",
    00000438 => x"00440413",
    00000439 => x"34141073",
    00000440 => x"f45ff06f",
    00000441 => x"fe802503",
    00000442 => x"01255513",
    00000443 => x"00157513",
    00000444 => x"00008067",
    00000445 => x"fa002023",
    00000446 => x"fe002703",
    00000447 => x"00151513",
    00000448 => x"00000793",
    00000449 => x"04a77463",
    00000450 => x"000016b7",
    00000451 => x"00000713",
    00000452 => x"ffe68693",
    00000453 => x"04f6e663",
    00000454 => x"00367613",
    00000455 => x"0035f593",
    00000456 => x"fff78793",
    00000457 => x"01461613",
    00000458 => x"00c7e7b3",
    00000459 => x"01659593",
    00000460 => x"01871713",
    00000461 => x"00b7e7b3",
    00000462 => x"00e7e7b3",
    00000463 => x"10000737",
    00000464 => x"00e7e7b3",
    00000465 => x"faf02023",
    00000466 => x"00008067",
    00000467 => x"00178793",
    00000468 => x"01079793",
    00000469 => x"40a70733",
    00000470 => x"0107d793",
    00000471 => x"fa9ff06f",
    00000472 => x"ffe70513",
    00000473 => x"0fd57513",
    00000474 => x"00051a63",
    00000475 => x"0037d793",
    00000476 => x"00170713",
    00000477 => x"0ff77713",
    00000478 => x"f9dff06f",
    00000479 => x"0017d793",
    00000480 => x"ff1ff06f",
    00000481 => x"00040737",
    00000482 => x"fa002783",
    00000483 => x"00e7f7b3",
    00000484 => x"fe079ce3",
    00000485 => x"faa02223",
    00000486 => x"00008067",
    00000487 => x"fa002783",
    00000488 => x"00100513",
    00000489 => x"0007c863",
    00000490 => x"0107d513",
    00000491 => x"00154513",
    00000492 => x"00157513",
    00000493 => x"00008067",
    00000494 => x"fa402503",
    00000495 => x"fe055ee3",
    00000496 => x"0ff57513",
    00000497 => x"00008067",
    00000498 => x"ff010113",
    00000499 => x"00812423",
    00000500 => x"01212023",
    00000501 => x"00112623",
    00000502 => x"00912223",
    00000503 => x"00050413",
    00000504 => x"00a00913",
    00000505 => x"00044483",
    00000506 => x"00140413",
    00000507 => x"00049e63",
    00000508 => x"00c12083",
    00000509 => x"00812403",
    00000510 => x"00412483",
    00000511 => x"00012903",
    00000512 => x"01010113",
    00000513 => x"00008067",
    00000514 => x"01249663",
    00000515 => x"00d00513",
    00000516 => x"f75ff0ef",
    00000517 => x"00048513",
    00000518 => x"f6dff0ef",
    00000519 => x"fc9ff06f",
    00000520 => x"fe802503",
    00000521 => x"01055513",
    00000522 => x"00157513",
    00000523 => x"00008067",
    00000524 => x"00100793",
    00000525 => x"01f00713",
    00000526 => x"00a797b3",
    00000527 => x"00a74a63",
    00000528 => x"fc802703",
    00000529 => x"00f747b3",
    00000530 => x"fcf02423",
    00000531 => x"00008067",
    00000532 => x"fcc02703",
    00000533 => x"00f747b3",
    00000534 => x"fcf02623",
    00000535 => x"00008067",
    00000536 => x"fc000793",
    00000537 => x"00a7a423",
    00000538 => x"00b7a623",
    00000539 => x"00008067",
    00000540 => x"ff010113",
    00000541 => x"c81026f3",
    00000542 => x"c0102773",
    00000543 => x"c81027f3",
    00000544 => x"fed79ae3",
    00000545 => x"00e12023",
    00000546 => x"00f12223",
    00000547 => x"00012503",
    00000548 => x"00412583",
    00000549 => x"01010113",
    00000550 => x"00008067",
    00000551 => x"fe802503",
    00000552 => x"01155513",
    00000553 => x"00157513",
    00000554 => x"00008067",
    00000555 => x"f9000793",
    00000556 => x"fff00713",
    00000557 => x"00e7a423",
    00000558 => x"00b7a623",
    00000559 => x"00a7a423",
    00000560 => x"00008067",
    00000561 => x"69617641",
    00000562 => x"6c62616c",
    00000563 => x"4d432065",
    00000564 => x"0a3a7344",
    00000565 => x"203a6820",
    00000566 => x"706c6548",
    00000567 => x"3a72200a",
    00000568 => x"73655220",
    00000569 => x"74726174",
    00000570 => x"3a75200a",
    00000571 => x"6c705520",
    00000572 => x"0a64616f",
    00000573 => x"203a6520",
    00000574 => x"63657845",
    00000575 => x"00657475",
    00000576 => x"746f6f42",
    00000577 => x"2e676e69",
    00000578 => x"0a0a2e2e",
    00000579 => x"00000000",
    00000580 => x"52450a07",
    00000581 => x"5f524f52",
    00000582 => x"00000000",
    00000583 => x"69617741",
    00000584 => x"676e6974",
    00000585 => x"6f656e20",
    00000586 => x"32337672",
    00000587 => x"6578655f",
    00000588 => x"6e69622e",
    00000589 => x"202e2e2e",
    00000590 => x"00000000",
    00000591 => x"00004b4f",
    00000592 => x"00007830",
    00000593 => x"3c0a0a0a",
    00000594 => x"454e203c",
    00000595 => x"3356524f",
    00000596 => x"6f422032",
    00000597 => x"6f6c746f",
    00000598 => x"72656461",
    00000599 => x"0a3e3e20",
    00000600 => x"444c420a",
    00000601 => x"4d203a56",
    00000602 => x"20207961",
    00000603 => x"30322039",
    00000604 => x"480a3232",
    00000605 => x"203a5657",
    00000606 => x"00000020",
    00000607 => x"4b4c430a",
    00000608 => x"0020203a",
    00000609 => x"53494d0a",
    00000610 => x"00203a41",
    00000611 => x"5550430a",
    00000612 => x"0020203a",
    00000613 => x"434f530a",
    00000614 => x"0020203a",
    00000615 => x"454d490a",
    00000616 => x"00203a4d",
    00000617 => x"74796220",
    00000618 => x"40207365",
    00000619 => x"00000000",
    00000620 => x"454d440a",
    00000621 => x"00203a4d",
    00000622 => x"00000a0a",
    00000623 => x"444d430a",
    00000624 => x"00203e3a",
    00000625 => x"0000000a",
    00000626 => x"65206f4e",
    00000627 => x"75636578",
    00000628 => x"6c626174",
    00000629 => x"76612065",
    00000630 => x"616c6961",
    00000631 => x"2e656c62",
    00000632 => x"00000000",
    00000633 => x"61766e49",
    00000634 => x"2064696c",
    00000635 => x"00444d43",
    00000636 => x"52455b0a",
    00000637 => x"00002052",
    00000638 => x"00000a5d",
    00000639 => x"33323130",
    00000640 => x"37363534",
    00000641 => x"62613938",
    00000642 => x"66656463"
  );

end neorv32_bootloader_image;
