module pixel_gen2(
    input clk,  
    input reset,    
    input up,
    input down,
    input left,
    input right,
    input video_on,
    input [9:0] x,
    input [9:0] y,
    output reg [11:0] rgb
    );
    
    
     // create 60Hz refresh tick
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0; // start of vsync(vertical retrace)
    
    
     //BALL
    // round ball from square image
    wire [2:0] rom_addr1, rom_addr2, rom_addr3, rom_addr4, rom_addr5, rom_addr6;
    wire [2:0] rom_col1, rom_col2, rom_col3, rom_col4, rom_col5, rom_col6;                    
    wire [7:0] rom_data1, rom_data2, rom_data3, rom_data4, rom_data5, rom_data6;             // data at current rom address
    wire rom_bit1, rom_bit2, rom_bit3, rom_bit4, rom_bit5, rom_bit6;        // signify when rom data is 1 or 0 for ball rgb control
    // positive or negative ball velocity
    parameter BALL_VELOCITY = 3;
    // square rom boundaries
    parameter BALL_SIZE = 8;
    
    
    // ball rom
    ball_rom ball1(.addr(rom_addr1), .data(rom_data1));
    ball_rom ball2(.addr(rom_addr2), .data(rom_data2));
    ball_rom ball3(.addr(rom_addr3), .data(rom_data3));
    ball_rom ball4(.addr(rom_addr4), .data(rom_data4));
    ball_rom ball5(.addr(rom_addr5), .data(rom_data5));
    ball_rom ball6(.addr(rom_addr6), .data(rom_data6));
        
        
    
    
    
    
    parameter X_BALL_L1 = 165;
    parameter X_BALL_R1 = 165 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t1, y_ball_b1;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg1, y_ball_next1;      
    
    //BALL 2 ˆzellikleri
    parameter X_BALL_L2 = 190;
    parameter X_BALL_R2 = 190 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t2, y_ball_b2;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg2, y_ball_next2;
    
    
    //BALL 3 ˆzellikleri x-eksen
    parameter Y_BALL_T3 = 74;
    parameter Y_BALL_B3 = 74 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] x_ball_l3, x_ball_r3;
    // register to track top boundary and buffer
    reg [9:0] x_ball_reg3, x_ball_next3;
    
    
    // BALL 4 ˆzellikleri x-eksen
    parameter Y_BALL_T4 = 106;
    parameter Y_BALL_B4 = 106 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] x_ball_l4, x_ball_r4;
    // register to track top boundary and buffer
    reg [9:0] x_ball_reg4, x_ball_next4;     
    
    
    //BALL 5 ˆzellikleri
    parameter X_BALL_L5 = 394;
    parameter X_BALL_R5 = 394 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t5, y_ball_b5;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg5, y_ball_next5;   
    
    
    // BALL 6 ˆzellikleri
    parameter X_BALL_L6 = 426;
    parameter X_BALL_R6 = 426 + BALL_SIZE;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t6, y_ball_b6;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg6, y_ball_next6;       
    
         
    
    // OBJECT STATUS SIGNALS
    wire sq_ball_on1, ball_on1;
    wire sq_ball_on2, ball_on2;
    wire sq_ball_on3, ball_on3;
    wire sq_ball_on4, ball_on4;
    wire sq_ball_on5, ball_on5;
    wire sq_ball_on6, ball_on6;
    
    wire [11:0] ball_rgb1;
    wire [11:0] ball_rgb2;
    wire [11:0] ball_rgb3;
    wire [11:0] ball_rgb4;
    wire [11:0] ball_rgb5;
    wire [11:0] ball_rgb6;
    
    assign ball_rgb1 = 12'hFFF;      // white ball
    assign ball_rgb2 = 12'hFFF;      // white ball
    assign ball_rgb3 = 12'hFFF;
    assign ball_rgb4 = 12'hFFF;
    assign ball_rgb5 = 12'hFFF;
    assign ball_rgb6 = 12'hFFF;
    
    
    // rom data square boundaries
    assign y_ball_t1 = y_ball_reg1;
    assign y_ball_b1 = y_ball_t1 + BALL_SIZE - 1;
    
    assign y_ball_t2 = y_ball_reg2;
    assign y_ball_b2 = y_ball_t2 + BALL_SIZE - 1;
    
    assign x_ball_l3 = x_ball_reg3;
    assign x_ball_r3 = x_ball_l3 + BALL_SIZE - 1;
    
    assign x_ball_l4 = x_ball_reg4;
    assign x_ball_r4 = x_ball_l4 + BALL_SIZE - 1;
    
    assign y_ball_t5 = y_ball_reg5;
    assign y_ball_b5 = y_ball_t5 + BALL_SIZE - 1;
    
    assign y_ball_t6 = y_ball_reg6;
    assign y_ball_b6 = y_ball_t6 + BALL_SIZE - 1;
    
    
    // pixel within rom square boundaries
    assign sq_ball_on1 = (X_BALL_L1 <= x) && (x <= X_BALL_R1) &&     // pixel within paddle boundaries
                         (y_ball_t1 <= y) && (y <= y_ball_b1);
                        
    assign sq_ball_on2 = (X_BALL_L2 <= x) && (x <= X_BALL_R2) &&     // pixel within paddle boundaries
                         (y_ball_t2 <= y) && (y <= y_ball_b2);
      
    assign sq_ball_on3 = (Y_BALL_T3 <= y) && (y <= Y_BALL_B3) &&     // pixel within paddle boundaries
                         (x_ball_l3 <= x) && (x <= x_ball_r3);
                         
    assign sq_ball_on4 = (Y_BALL_T4 <= y) && (y <= Y_BALL_B4) &&     // pixel within paddle boundaries
                         (x_ball_l4 <= x) && (x <= x_ball_r4);
                        
    assign sq_ball_on5 = (X_BALL_L5 <= x) && (x <= X_BALL_R5) &&     // pixel within paddle boundaries
                         (y_ball_t5 <= y) && (y <= y_ball_b5);
                        
    assign sq_ball_on6 = (X_BALL_L6 <= x) && (x <= X_BALL_R6) &&     // pixel within paddle boundaries
                         (y_ball_t6 <= y) && (y <= y_ball_b6);
                        
                        
                        
    // map current pixel location to rom addr/col
    //assign rom_addr = x[2:0] - 200;   // 3-bit address
    //assign rom_col = y[2:0] - y_ball_t1[2:0];    // 3-bit column index
    
    assign rom_addr1 = x[2:0] - X_BALL_L1;
    assign rom_addr2 = x[2:0] - X_BALL_L2;
    assign rom_addr3 = y[2:0] - Y_BALL_T3;
    assign rom_addr4 = y[2:0] - Y_BALL_T4;
    assign rom_addr5 = x[2:0] - X_BALL_L5;
    assign rom_addr6 = x[2:0] - X_BALL_L6;

    assign rom_col1 = y[2:0] - y_ball_t1[2:0];
    assign rom_col2 = y[2:0] - y_ball_t2[2:0];
    assign rom_col3 = x[2:0] - x_ball_l3[2:0];
    assign rom_col4 = x[2:0] - x_ball_l4[2:0];
    assign rom_col5 = y[2:0] - y_ball_t5[2:0];
    assign rom_col6 = y[2:0] - y_ball_t6[2:0];
    
    assign rom_bit1 = rom_data1[rom_col1];
    assign rom_bit2 = rom_data2[rom_col2];
    assign rom_bit3 = rom_data3[rom_col3];
    assign rom_bit4 = rom_data4[rom_col4];
    assign rom_bit5 = rom_data5[rom_col5];
    assign rom_bit6 = rom_data6[rom_col6];

    
    // pixel within round ball
    assign ball_on1 = sq_ball_on1 & rom_bit1;      // within square boundaries AND rom data bit == 1
    assign ball_on2 = sq_ball_on2 & rom_bit2; 
    assign ball_on3 = sq_ball_on3 & rom_bit3; 
    assign ball_on4 = sq_ball_on4 & rom_bit4;
    assign ball_on5 = sq_ball_on5 & rom_bit5;
    assign ball_on6 = sq_ball_on6 & rom_bit6; 
    
    //ball direction
    localparam UP = 1'b0;
    localparam DOWN = 1'b1;
    localparam LEFT = 1'b0;
    localparam RIGHT = 1'b1;
    reg direction1, direction_next1;
    reg direction2, direction_next2;
    reg direction3, direction_next3;
    reg direction4, direction_next4;
    
     // change ball direction after collision
    always @* begin
        direction_next1 = direction1;
        direction_next2 = direction2;
        direction_next3 = direction3;
        direction_next4 = direction4;
        
        y_ball_next1 = y_ball_reg1;
        y_ball_next2 = y_ball_reg2;
        x_ball_next3 = x_ball_reg3;
        x_ball_next4 = x_ball_reg4;
        
        if(refresh_tick) begin
            case(direction1) 
                LEFT: begin
                    if(x_ball_reg3 > 160)
                        x_ball_next3 = x_ball_reg3 - BALL_VELOCITY;
                    else
                        direction_next1 = RIGHT;
                end
               
                RIGHT: begin
                    if(x_ball_reg3 < 436)
                        x_ball_next3 = x_ball_reg3 + BALL_VELOCITY;
                    else
                        direction_next1 = LEFT;
                end
              
            endcase
            case(direction2) 
                LEFT: begin
                    if(x_ball_reg4 > 160)
                        x_ball_next4 = x_ball_reg4 - BALL_VELOCITY;
                    else
                        direction_next2 = RIGHT;
                end
               
                RIGHT: begin
                    if(x_ball_reg4 < 436)
                        x_ball_next4 = x_ball_reg4 + BALL_VELOCITY;
                    else
                        direction_next2 = LEFT;
                end
            endcase
            case(direction3) //a?a?? yukar?
                UP: begin
                    if(y_ball_reg1 > 65 && y_ball_reg5 > 65) begin
                        y_ball_next1 = y_ball_reg1 - BALL_VELOCITY;
                        y_ball_next5 = y_ball_reg5 - BALL_VELOCITY;
                    end else
                        direction_next3 = DOWN;
                   
                end
               
                DOWN: begin
                    if(y_ball_reg1 < 372 && y_ball_reg5 < 372) begin
                        y_ball_next1 = y_ball_reg1 + BALL_VELOCITY;
                        y_ball_next5 = y_ball_reg5 + BALL_VELOCITY;
                    end else
                        direction_next3 = UP;
                end
            endcase
            case(direction4)
                UP: begin
                    if(y_ball_reg2 > 65 && y_ball_reg6 > 65) begin
                        y_ball_next2 = y_ball_reg2 - BALL_VELOCITY;
                        y_ball_next6 = y_ball_reg6 - BALL_VELOCITY;
                    end else
                        direction_next4 = DOWN;
                end
               
                DOWN: begin
                    if(y_ball_reg2 < 372 && y_ball_reg6 < 372) begin
                        y_ball_next2 = y_ball_reg2 + BALL_VELOCITY;
                        y_ball_next6 = y_ball_reg6 + BALL_VELOCITY;
                    end else
                        direction_next4 = UP;
                end
            endcase
        end
    end    
    
    
     initial begin
        direction1 = 0;
        direction2 = 1;
        direction3 = 0;
        direction4 = 1;
    end
    
     // Register Control
    always @(posedge clk or posedge reset)
        if(reset) begin
            y_ball_reg1 <= 65;
            direction3 <= 0;
            
            y_ball_reg2 <= 64;
            direction4 <= 1;
            
            x_ball_reg3 <= 160;
            direction1 <= 0;
            
            x_ball_reg4 <= 436;
            direction2 <= 1;
            
            y_ball_reg5 <= 64;
            y_ball_reg6 <= 372;
        end
        else begin
            y_ball_reg1 <= y_ball_next1;
            direction1 <= direction_next1;
            
            y_ball_reg2 <= y_ball_next2;
            direction2 <= direction_next2;
            
            x_ball_reg3 <= x_ball_next3;
            direction3 <= direction_next3;
             
            x_ball_reg4 <= x_ball_next4;
            direction4 <= direction_next4;
            
            y_ball_reg5 <= y_ball_next5;
            y_ball_reg6 <= y_ball_next6;
        end
    
    
    
    //MAP ýSLEMLERý
    parameter TRANSPARENT_COLOR = 8'b11010111;
    parameter SKY_COLOR = 8'b11100000;

    // Bellek adresi
    wire [10:0] addr_sprite;
    wire sprite_block;
    wire [8:0] addr_map;

    // Sprite belle?i Á?k???
    wire [7:0] sprite_out;



    // Sprite belle?i
    map2 mapa(.clk(clk), .en(1'b1), .addr(addr_map), .dataout(sprite_block));
    sprite sprite_mem(.clk(clk), .en(1'b1), .addr(addr_sprite), .dataout(sprite_out));
    

    
    // Sprite adres hesaplamas?
    assign addr_map = ((x >>5)*15)+(y>>5); // 15x20 harita boyutunda
    assign addr_sprite = (x % 32) + ((y % 32) << 5) + (sprite_block) * 1024;

    // Renk belirleme
    wire is_sky;
    assign is_sky = (sprite_out == TRANSPARENT_COLOR);

  
    
    // maximum x, y values in display area
    parameter X_MAX = 639;
    parameter Y_MAX = 479;
    
   
    
    
    
    
    // OYUNCU
    // oyuncu horizontal boundaries
    parameter PAD_HEIGHT = 12;  
    wire [9:0] x_pad_l, x_pad_r;   
    // oyuncu vertical boundary signals
    wire [9:0] y_pad_t, y_pad_b;
     // register to track top left position
    reg [9:0] y_pad_reg, x_pad_reg;
    // signals for register buffer
    reg [9:0] y_pad_next, x_pad_next;
    
    //ball movement distance
    parameter PAD_VELOCITY = 1;
    
    
    
     always @(posedge clk or posedge reset)
        if(reset) begin
            x_pad_reg <= 16;
            y_pad_reg <= 360;
        end
        else begin
            x_pad_reg <= x_pad_next;
            y_pad_reg <= y_pad_next;
        end
    
    wire pad_on, sq_pad_on;
    wire [11:0] pad_rgb, bg_rgb;
    assign pad_rgb = 12'hAAA;   
    
    assign x_pad_l = x_pad_reg;
    assign y_pad_t = y_pad_reg;
    assign x_pad_r = x_pad_l + (PAD_HEIGHT - 1);
    assign y_pad_b = y_pad_t + (PAD_HEIGHT - 1);
    
    // Pixel within oyuncu boundaries
    assign pad_on = (x >= x_pad_l) && (x <= x_pad_r) && 
                    (y >= y_pad_t) && (y <= y_pad_b);
                        
   
    //collision
    //ball1 ile
    wire collision1;
    assign collision1 = 
    (X_BALL_R1 >= x_pad_l) && (X_BALL_L1 <= x_pad_r) &&  // yatay Áarp??ma
    (y_ball_b1 >= y_pad_t) && (y_ball_t1 <= y_pad_b);   // dikey Áarp??ma
    
    wire collision2;
    assign collision2 = 
    (X_BALL_R2 >= x_pad_l) && (X_BALL_L2 <= x_pad_r) &&  // yatay Áarp??ma
    (y_ball_b2 >= y_pad_t) && (y_ball_t2 <= y_pad_b);   // dikey Áarp??ma
    
    wire collision3;
    assign collision3 = 
    (Y_BALL_B3 >= y_pad_t) && (Y_BALL_T3 <= y_pad_b) &&  // yatay Áarp??ma
    (x_ball_r3 >= x_pad_l) && (x_ball_l3 <= x_pad_r);   // dikey Áarp??ma
    
    wire collision4;
    assign collision4 = 
    (Y_BALL_B4 >= y_pad_t) && (Y_BALL_T4 <= y_pad_b) &&  // yatay Áarp??ma
    (x_ball_r4 >= x_pad_l) && (x_ball_l4 <= x_pad_r);   // dikey Áarp??ma
    
    wire collision5;
    assign collision5 = 
    (X_BALL_R5 >= x_pad_l) && (X_BALL_L5 <= x_pad_r) &&  // yatay Áarp??ma
    (y_ball_b5 >= y_pad_t) && (y_ball_t5 <= y_pad_b);   // dikey Áarp??ma
    
    wire collision6;
    assign collision6 = 
    (X_BALL_R6 >= x_pad_l) && (X_BALL_L6 <= x_pad_r) &&  // yatay Áarp??ma
    (y_ball_b6 >= y_pad_t) && (y_ball_t6 <= y_pad_b);   // dikey Áarp??ma
    
    
    
    
    //Oyuncu hareketi
    always @* begin
        y_pad_next = y_pad_reg; // Default: paddle hareket etmez
        x_pad_next = x_pad_reg; 
        
        // Harita kontrol¸: ¸st, alt, sa?, sol
        if (refresh_tick) begin
            if(collision1 ||collision2 ||collision3 ||collision4 || collision5 ||collision6) begin
                y_pad_next = 360;
                x_pad_next = 16;

            end else begin
                // Yukar? hareket kontrol¸
                if (up)
                    if((x_pad_reg > 0 && x_pad_reg <= 160 &&  y_pad_reg > 320) || (x_pad_reg >= 160 && x_pad_reg < 448 && y_pad_reg > 64) || (x_pad_reg > 448 && y_pad_reg > 320))
                        y_pad_next = y_pad_reg - PAD_VELOCITY;
                   
        
                // A?a?? hareket kontrol¸
                if (down)
                    if ((x_pad_reg > 0 && x_pad_reg <= 224 &&  y_pad_reg < 372)|| (x_pad_reg >= 224 && x_pad_reg <384 && y_pad_reg < 116) || ((x_pad_reg >= 384 && y_pad_reg < 372)))
                        y_pad_next = y_pad_reg + PAD_VELOCITY;
                    
                    
        
                // Sol hareket kontrol¸
                if (left)
                    if((y_pad_reg >= 320 && y_pad_reg < 384 && x_pad_reg <= 224) || (y_pad_reg < 320 && y_pad_reg > 63 && x_pad_reg > 160 && x_pad_reg < 225) 
                    || (y_pad_reg > 63 && y_pad_reg < 128 && x_pad_reg > 224 && x_pad_reg < 448) || (y_pad_reg > 128 && y_pad_reg < 384 && x_pad_reg > 384 && x_pad_reg < 448)
                    || (y_pad_reg > 319 && y_pad_reg < 384 && x_pad_reg >= 448))
                        x_pad_next = x_pad_reg - PAD_VELOCITY;
                        
                        
        
                // Sa? hareket kontrol¸
                if (right)  
                    if((y_pad_reg >= 320 && y_pad_reg < 384 && x_pad_reg <= 160) || (y_pad_reg < 384 && y_pad_reg > 128 && x_pad_reg >= 160 && x_pad_reg < 212) 
                    || (y_pad_reg > 63 && y_pad_reg < 128 && x_pad_reg >= 160 && x_pad_reg <= 384) || (y_pad_reg > 63 && y_pad_reg < 320 && x_pad_reg >= 384 && x_pad_reg <= 448)
                    || (y_pad_reg > 319 && y_pad_reg < 384 && x_pad_reg > 384))
                    x_pad_next = x_pad_reg + PAD_VELOCITY;
             end
             
             
        end
        
        
        
    end



    
        always @* begin
        if (~video_on)
            rgb = 12'h000; // Siyah ekran
        else if (ball_on1)
            rgb = ball_rgb1; // Ball1 rengi
        else if (ball_on2)
            rgb = ball_rgb2; // Ball2 rengi
        else if (ball_on3)
            rgb = ball_rgb3; // Ball3 rengi
        else if (ball_on4)
            rgb = ball_rgb4; // Ball2 rengi
        else if (ball_on5)
            rgb = ball_rgb5; // Ball2 rengi
        else if (ball_on6)
            rgb = ball_rgb6; // Ball2 rengi
        //else if (ball_on5)
          //  rgb = ball_rgb5; // Ball2 rengi
        else if (pad_on)
            rgb = pad_rgb; // Paddle rengi
        else if (is_sky)
            rgb = SKY_COLOR; // Gˆky¸z¸ rengi
        else
            rgb = sprite_out; // Sprite rengi
    end
    


endmodule