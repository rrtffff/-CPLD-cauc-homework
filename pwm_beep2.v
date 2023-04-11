module pwm_beep2(
    input clk,
    input rst_n,
    output reg beep
);

parameter M1 = 17'd95600;
parameter M2 = 17'd85150;
parameter M3 = 17'd75850;
parameter M4 = 17'd71600;
parameter M5 = 17'd63750;
parameter M6 = 17'd56800;
parameter M7 = 17'd50600;

reg [16:0] cnt0;//音符周期计数器
wire add_cnt0;
wire end_cnt0;

reg [8:0] cnt1;//音符重复次数计数器
wire add_cnt1;
wire end_cnt1;

reg [4:0] cnt2;//音符总次数
wire add_cnt2;
wire end_cnt2;

reg 	[16:0] preset_note;//预设音符周期数
wire 	[16:0] preset_duty;//占空比
//音符周期计数
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 17'b0;
    end
    else if(add_cnt0)begin
        if(end_cnt0)begin
            cnt0 <= 17'b0;
        end
        else begin
            cnt0 <= cnt0 +1'b1;
        end
    end
end
assign add_cnt0 = 1'b1;
assign end_cnt0 = add_cnt0 && (cnt0 == preset_note - 1);

//音符重复次数
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 9'b0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)begin
            cnt1 <= 9'b0;
        end
        else begin
            cnt1 <= cnt1 +1'b1;
        end
    end
end
assign add_cnt1 = end_cnt0;
assign end_cnt1 = add_cnt1 && (cnt1 == 299);

//音符总次数
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt2 <= 5'b0;
    end
    else if(add_cnt2)begin
        if(end_cnt2)begin
            cnt2 <= 5'b0;
        end
        else begin
            cnt2 <= cnt2 +1'b1;
        end
    end
end
assign add_cnt2 = end_cnt1;
assign end_cnt2 = add_cnt2 && (cnt2 == 31);

//给音符周期赋值 对照乐谱的音符位置赋值
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        preset_note <= 17'b0;
    end
    else begin
        case(cnt2)
            6'd0    :   preset_note <= M1;
            6'd1    :   preset_note <= M2;
            6'd2    :   preset_note <= M3;
            6'd3    :   preset_note <= M1;
            6'd4    :   preset_note <= M1;
            6'd5    :   preset_note <= M2;
            6'd6    :   preset_note <= M3;
            6'd7    :   preset_note <= M1;
            6'd8    :   preset_note <= M3;
            6'd9    :   preset_note <= M4;
            6'd10   :   preset_note <= M5;
            6'd11   :   preset_note <= M3;
            6'd12   :   preset_note <= M4;
            6'd13   :   preset_note <= M5;
            6'd14   :   preset_note <= M5;
            6'd15   :   preset_note <= M6;
            6'd16   :   preset_note <= M5;
            6'd17   :   preset_note <= M4;
            6'd18   :   preset_note <= M3;
            6'd19   :   preset_note <= M1;
            6'd20   :   preset_note <= M5;
            6'd21   :   preset_note <= M6;
            6'd22   :   preset_note <= M5;
            6'd23   :   preset_note <= M4;
            6'd24   :   preset_note <= M3;
            6'd25   :   preset_note <= M1;
            6'd26   :   preset_note <= M2;
            6'd27   :   preset_note <= M5;
            6'd28   :   preset_note <= M1;
            6'd29   :   preset_note <= M2;
            6'd30   :   preset_note <= M5;
            6'd31   :   preset_note <= M1;
            default :   preset_note <= M1;
        endcase
    end
end

//给蜂鸣器赋值，并设定占空比
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        beep <= 1'b1;
    end
    else if(cnt0 <= preset_duty)begin
        beep <= 1'b0;//蜂鸣器低电平有效
    end
    else begin
        beep <= 1'b1;
    end
end
assign preset_duty = preset_note >> 1;//50%占空比
endmodule
