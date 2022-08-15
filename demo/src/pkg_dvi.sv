
package pkg_dvi;

    // video timing parameters for 1080p, CEA-861
    // params are ugly but will do for now
    parameter H_ACTIVE      = 1920;
    parameter V_ACTIVE      = 1080;
    parameter H_FULL        = 2200;
    parameter V_FULL        = 1125;
    parameter H_SYNC_START  = 2008;
    parameter H_SYNC_END    = 2052;
    parameter V_SYNC_START  = 1084;
    parameter V_SYNC_END    = 1089;

    parameter C0 = 10'b1101010100;
    parameter C1 = 10'b0010101011;
    parameter C2 = 10'b0101010100;
    parameter C3 = 10'b1010101011;
    
    typedef logic [7:0]         byte_t;
    typedef logic [9:0]         tmds_t;
    typedef logic [1:0]         dvi_control_t;
    typedef logic signed [7:0]  disparity_t;
    
    typedef struct packed 
    {
        tmds_t          tmds_char;
        disparity_t     disparity;
    } tmds_encoded_t;
    
    typedef struct packed
    {
        byte_t          databyte;
        logic           is_control;
        logic           decode_error;
        dvi_control_t   control;
    } tmds_decoded_t;
    
    // a synthesizable version of $countones, restricted to a byte
    // can only return up to 8 despite return type
    function automatic int countones(
        input byte_t    data_in
    );
        int             count='0;
    begin
        foreach(data_in[i]) count = count + data_in[i];
        return count;
    end
    endfunction
    
    // helper functions
    function automatic disparity_t zeros_minus_ones(
        input byte_t    inbyte
    );
        int             count;
        disparity_t     fout;
    begin
        count = countones(inbyte);
        case(count)
            0: fout = 8'sd8;    // 8-0
            1: fout = 8'sd6;    // 7-1
            2: fout = 8'sd4;    // 6-2
            3: fout = 8'sd2;    // 5-3
            4: fout = 8'sd0;    // 4-4
            5: fout = -8'sd2;   // 3-5
            6: fout = -8'sd4;   // 2-6
            7: fout = -8'sd6;   // 1-7
            8: fout = -8'sd8;   // 0-8
            default fout = 8'sd0;
        endcase
        return fout;
    end
    endfunction
    
    function automatic disparity_t ones_minus_zeros(
        input byte_t    inbyte
    );
        int             count;
        disparity_t     fout;
    begin
        count = 8 - countones(inbyte);
        case(count)
            0: fout = 8'sd8;    // 8-0
            1: fout = 8'sd6;    // 7-1
            2: fout = 8'sd4;    // 6-2
            3: fout = 8'sd2;    // 5-3
            4: fout = 8'sd0;    // 4-4
            5: fout = -8'sd2;   // 3-5
            6: fout = -8'sd4;   // 2-6
            7: fout = -8'sd6;   // 1-7
            8: fout = -8'sd8;   // 0-8
            default fout = 8'sd0;
        endcase
        return fout;
    end
    endfunction
    
    // do TMDS encoding roughly following Figure 3-5 in DVI 1.0 spec
    function automatic tmds_encoded_t tmds_encode(
        input byte_t        data_in,
        input logic         data_en,
        input dvi_control_t control,
        input disparity_t   disparity
    );
        logic [8:0]         temp9;
    begin
        // spec has this after next step but it doesn't really matter?
        if (data_en == 0) begin
            tmds_encode.disparity = disparity; //the control chars are balanced
            case(control) // icarus doesn't support unique case https://github.com/steveicarus/iverilog/issues/255
                2'b00: tmds_encode.tmds_char = C0;
                2'b01: tmds_encode.tmds_char = C1;
                2'b10: tmds_encode.tmds_char = C2;
                2'b11: tmds_encode.tmds_char = C3;
            endcase
            return tmds_encode;
        end
        // choose XOR or XNOR based on number of ones in databyte
        if ((countones(data_in) > 4) || ((countones(data_in)==4) && (data_in[0]=='0)))
            for (int i=0; i<9; i=i+1) begin
                if (i==0)
                    temp9[i] = data_in[i];
                else if (i < 8)
                    temp9[i] = temp9[i-1] ~^ data_in[i];
                else
                    temp9[i] = '0;
            end
        else
            for (int i=0; i<9; i=i+1) begin
                if (i==0)
                    temp9[i] = data_in[i];
                else if (i < 8)
                    temp9[i] = temp9[i-1] ^ data_in[i];
                else
                    temp9[i] = '1;
            end
        if ((disparity == 0) || (countones(temp9[7:0])==4)) begin
            tmds_encode.tmds_char[9]  = ~temp9[8];
            tmds_encode.tmds_char[8]  =  temp9[8];
            tmds_encode.tmds_char[7:0] = temp9[8] ? temp9[7:0] : ~temp9[7:0];
            if (temp9[8]==0)
                tmds_encode.disparity = disparity + zeros_minus_ones(temp9[7:0]);
            else
                tmds_encode.disparity = disparity + ones_minus_zeros(temp9[7:0]);
        end else begin
            if (((disparity > 0) && (countones(temp9[7:0]) >= 5))
            ||  ((disparity < 0) && (countones(temp9[7:0]) <= 3))) begin
                tmds_encode.tmds_char[9]  = '1;
                tmds_encode.tmds_char[8]  =  temp9[8];
                tmds_encode.tmds_char[7:0] = ~temp9[7:0];
                tmds_encode.disparity = disparity + (temp9[8] ? 8'sd2 : 8'sd0);
                tmds_encode.disparity = tmds_encode.disparity + zeros_minus_ones(temp9[7:0]);
            end else begin
                tmds_encode.tmds_char[9]  = '0;
                tmds_encode.tmds_char[8]  =  temp9[8];
                tmds_encode.tmds_char[7:0] = temp9[7:0];
                tmds_encode.disparity = disparity - (temp9[8] ? 8'sd0 : 8'sd2);
                tmds_encode.disparity = tmds_encode.disparity + ones_minus_zeros(temp9[7:0]);
            end
        end
        return tmds_encode;
    end
    endfunction

    // TMDS decode according to Figure 3-6 in DVI 1.0 spec
    function automatic tmds_decoded_t tmds_decode(
        input tmds_t        data_in,
        input logic         data_active
    );
        tmds_t              temp;
        byte_t              bytetemp;
    begin
        tmds_decode = '0;
        if (data_active) begin
            temp = data_in;
            if (data_in[9])
                temp[7:0] = ~temp[7:0];
            if (data_in[8]) begin
                bytetemp[0] = temp[0];
                for (integer i=1; i<8; i=i+1) begin
                    bytetemp[i] = temp[i-1] ^ temp[i];
                end
            end else begin
                bytetemp[0] = temp[0];
                for (integer i=1; i<8; i=i+1) begin
                    bytetemp[i] = temp[i-1] ~^ temp[i];
                end
            end
            tmds_decode.databyte = bytetemp;
        end else begin
            tmds_decode.is_control = '1;
            case(data_in)
                C0: tmds_decode.control = 2'b00;
                C1: tmds_decode.control = 2'b01;
                C2: tmds_decode.control = 2'b10;
                C3: tmds_decode.control = 2'b11;
                default: tmds_decode.decode_error = '1;
            endcase
        end
    end
    endfunction

endpackage
