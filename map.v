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
    wire [2:0] rom_addr1, rom_addr2, rom_addr3, rom_addr4, rom_addr5;
    wire [2:0] rom_col1, rom_col2, rom_col3, rom_col4, rom_col5;
    wire [7:0] rom_data1, rom_data2, rom_data3, rom_data4, rom_data5;             // data at current rom address
    wire rom_bit1, rom_bit2, rom_bit3, rom_bit4, rom_bit5;                   // signify when rom data is 1 or 0 for ball rgb control
    // positive or negative ball velocity
    parameter BALL_VELOCITY = 1;
    // square rom boundaries
    parameter BALL_SIZE = 8;
    
    
    // ball rom
    ball_rom ball1(.addr(rom_addr1), .data(rom_data1));
    ball_rom ball2(.addr(rom_addr2), .data(rom_data2));
    ball_rom ball3(.addr(rom_addr3), .data(rom_data3));
    ball_rom ball4(.addr(rom_addr4), .data(rom_data4));
    ball_rom ball5(.addr(rom_addr5), .data(rom_data5));
        
        
        
    
    
    
    
    // BALL 1 özellikleri
    parameter X_BALL_L1 = 150;
    parameter X_BALL_R1 = 150 + BALL_SIZE;
    //start konum
    parameter start_y1 = 96;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t1, y_ball_b1;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg1, y_ball_next1;      
    
    //BALL 2 özellikleri
    parameter X_BALL_L2 = 230;
    parameter X_BALL_R2 = 230 + BALL_SIZE;
    //start konum
    parameter start_y2 = 376;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t2, y_ball_b2;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg2, y_ball_next2;
    
    
    //BALL 3 özellikleri
    parameter X_BALL_L3 = 310;
    parameter X_BALL_R3 = 310 + BALL_SIZE;
    //start konum
    parameter start_y3 = 96;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t3, y_ball_b3;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg3, y_ball_next3;
    
    
    // BALL 4 özellikleri
    parameter X_BALL_L4 = 380;
    parameter X_BALL_R4 = 380 + BALL_SIZE;
    //start konum
    parameter start_y4 = 376;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t4, y_ball_b4;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg4, y_ball_next4;     
    
    
    // BALL 5 özellikleri
    parameter X_BALL_L5 = 460;
    parameter X_BALL_R5 = 460 + BALL_SIZE;
    //start konum
    parameter start_y5 = 96;
    // ball horizontal boundary signals
    wire [9:0] y_ball_t5, y_ball_b5;
    // register to track top boundary and buffer
    reg [9:0] y_ball_reg5, y_ball_next5;     
    
    
    //ball direction
    localparam UP = 1'b0;
    localparam DOWN = 1'b1;
    reg direction1, direction2, direction3;
    reg direction_next1, direction_next2,direction_next3;
    
  
     
        
        
    
    // OBJECT STATUS SIGNALS
    wire sq_ball_on1, ball_on1;
    wire sq_ball_on2, ball_on2;
    wire sq_ball_on3, ball_on3;
    wire sq_ball_on4, ball_on4;
    wire sq_ball_on5, ball_on5;
    
    wire [11:0] ball_rgb1;
    wire [11:0] ball_rgb2;
    wire [11:0] ball_rgb3;
    wire [11:0] ball_rgb4;
    wire [11:0] ball_rgb5;
    
    assign ball_rgb1 = 12'hFFF;      // white ball
    assign ball_rgb2 = 12'hFFF;      // white ball
    assign ball_rgb3 = 12'hFFF;
    assign ball_rgb4 = 12'hFFF;
    assign ball_rgb5 = 12'hFFF;
    
    // rom data square boundaries
    assign y_ball_t1 = y_ball_reg1;
    assign y_ball_b1 = y_ball_t1 + BALL_SIZE - 1;
    
    assign y_ball_t2 = y_ball_reg2;
    assign y_ball_b2 = y_ball_t2 + BALL_SIZE - 1;
    
    assign y_ball_t3 = y_ball_reg3;
    assign y_ball_b3 = y_ball_t3 + BALL_SIZE - 1;
    
    assign y_ball_t4 = y_ball_reg4;
    assign y_ball_b4 = y_ball_t4 + BALL_SIZE - 1;
    
    assign y_ball_t5 = y_ball_reg5;
    assign y_ball_b5 = y_ball_t5 + BALL_SIZE - 1;
    
    // pixel within rom square boundaries
    assign sq_ball_on1 = (X_BALL_L1 <= x) && (x <= X_BALL_R1) &&     // pixel within paddle boundaries
                        (y_ball_t1 <= y) && (y <= y_ball_b1);
                        
    assign sq_ball_on2 = (X_BALL_L2 <= x) && (x <= X_BALL_R2) &&     // pixel within paddle boundaries
                        (y_ball_t2 <= y) && (y <= y_ball_b2);
     
    assign sq_ball_on3 = (X_BALL_L3 <= x) && (x <= X_BALL_R3) &&     // pixel within paddle boundaries
                        (y_ball_t3 <= y) && (y <= y_ball_b3);
                        
    assign sq_ball_on4 = (X_BALL_L4 <= x) && (x <= X_BALL_R4) &&     // pixel within paddle boundaries
                        (y_ball_t4 <= y) && (y <= y_ball_b4);
                        
    assign sq_ball_on5 = (X_BALL_L5 <= x) && (x <= X_BALL_R5) &&     // pixel within paddle boundaries
                        (y_ball_t5 <= y) && (y <= y_ball_b5);
                        
                        
    // map current pixel location to rom addr/col
    //assign rom_addr = x[2:0] - 200;   // 3-bit address
    //assign rom_col = y[2:0] - y_ball_t1[2:0];    // 3-bit column index
    
    assign rom_addr1 = x[2:0] - X_BALL_L1;
    assign rom_addr2 = x[2:0] - X_BALL_L2;
    assign rom_addr3 = x[2:0] - X_BALL_L3;
    assign rom_addr4 = x[2:0] - X_BALL_L4;
    assign rom_addr5 = x[2:0] - X_BALL_L5;

    assign rom_col1 = y[2:0] - y_ball_t1[2:0];
    assign rom_col2 = y[2:0] - y_ball_t2[2:0];
    assign rom_col3 = y[2:0] - y_ball_t3[2:0];
    assign rom_col4 = y[2:0] - y_ball_t4[2:0];
    assign rom_col5 = y[2:0] - y_ball_t5[2:0];
    
    assign rom_bit1 = rom_data1[rom_col1];
    assign rom_bit2 = rom_data2[rom_col2];
    assign rom_bit3 = rom_data3[rom_col3];
    assign rom_bit4 = rom_data4[rom_col4];
    assign rom_bit5 = rom_data5[rom_col5];

    
    // pixel within round ball
    assign ball_on1 = sq_ball_on1 & rom_bit1;      // within square boundaries AND rom data bit == 1
    assign ball_on2 = sq_ball_on2 & rom_bit2; 
    assign ball_on3 = sq_ball_on3 & rom_bit3; 
    assign ball_on4 = sq_ball_on4 & rom_bit4;
    assign ball_on5 = sq_ball_on5 & rom_bit5;
    
    
     // change ball direction after collision
    always @* begin
        y_ball_next1 = y_ball_reg1;
        direction_next1 = direction1;
        
        y_ball_next2 = y_ball_reg2;
        direction_next2 = direction2;
        
        y_ball_next3 = y_ball_reg3;
      
        
        y_ball_next4 = y_ball_reg4;
   
        
        y_ball_next5 = y_ball_reg5;
     
        
        if(refresh_tick) begin
            case(direction1) 
                UP: begin
                    if(y_ball_reg1 > 96 && y_ball_reg3 > 96 && y_ball_reg5 > 96) begin
                        y_ball_next1 = y_ball_reg1 - BALL_VELOCITY;
                        y_ball_next3 = y_ball_reg3 - BALL_VELOCITY;
                        y_ball_next5 = y_ball_reg5 - BALL_VELOCITY;
                    end else begin
                        direction_next1 = DOWN;
                    end
                end
                
                DOWN: begin
                    if(y_ball_reg1 < 376  && y_ball_reg3 < 376 && y_ball_reg5 < 376) begin
                        y_ball_next1 = y_ball_reg1 + BALL_VELOCITY;
                        y_ball_next3 = y_ball_reg3 + BALL_VELOCITY;
                        y_ball_next5 = y_ball_reg5 + BALL_VELOCITY;
                    end else begin
                        direction_next1 = UP;
                    end
                end
            endcase
            
            case(direction2) 
                UP: begin
                    if(y_ball_reg2 > 96 && y_ball_reg4 > 96) begin
                        y_ball_next2 = y_ball_reg2 - BALL_VELOCITY;
                        y_ball_next4 = y_ball_reg4 - BALL_VELOCITY;
                    end else begin
                        direction_next2 = DOWN;
                    end
                end
                
                DOWN: begin
                    if(y_ball_reg2 < 376 && y_ball_reg4 < 376) begin
                        y_ball_next2 = y_ball_reg2 + BALL_VELOCITY;
                        y_ball_next4 = y_ball_reg4 + BALL_VELOCITY;
                    end else begin
                        direction_next2 = UP;
                    end
                end
            endcase
        end
    end    
    
    
     // Register Control
    always @(posedge clk or posedge reset)
        if(reset) begin
            y_ball_reg1 <= start_y1;
            direction1 <= 0;
            
            y_ball_reg2 <= start_y2;
            direction2 <= 1;
            
            y_ball_reg3 <= start_y3;
            y_ball_reg4 <= start_y4;
            y_ball_reg5 <= start_y5;
        end
        else begin
            y_ball_reg1 <= y_ball_next1;
            direction1 <= direction_next1;
            
            y_ball_reg2 <= y_ball_next2;
            direction2 <= direction_next2;
            
            y_ball_reg3 <= y_ball_next3;
            y_ball_reg4 <= y_ball_next4;
            y_ball_reg5 <= y_ball_next5;
        end
    
    
    
    //MAP ÝSLEMLERÝ
    parameter TRANSPARENT_COLOR = 8'b11010111;
    parameter SKY_COLOR = 8'b11100000;

    // Bellek adresi
    wire [10:0] addr_sprite;
    wire sprite_block;
    wire [8:0] addr_map;

    // Sprite belleði çýkýþý
    wire [7:0] sprite_out;



    // Sprite belleði
    map2 mapa(.clk(clk), .en(1'b1), .addr(addr_map), .dataout(sprite_block));
    sprite sprite_mem(.clk(clk), .en(1'b1), .addr(addr_sprite), .dataout(sprite_out));
    

    
    // Sprite adres hesaplamasý
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
    
    // registers to track ball speed and buffers
    reg [9:0] x_delta_reg, x_delta_next;
    reg [9:0] y_delta_reg, y_delta_next;
    //ball movement distance
    parameter PAD_VELOCITY = 1;
    
    
    
     always @(posedge clk or posedge reset)
        if(reset) begin
            x_pad_reg <= 16;
            y_pad_reg <= 360;
            x_delta_reg <= 10'h002;
            y_delta_reg <= 10'h002;
        end
        else begin
            x_pad_reg <= x_pad_next;
            y_pad_reg <= y_pad_next;
            x_delta_reg <= x_delta_next;
            y_delta_reg <= y_delta_next;
            
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
    (X_BALL_R1 >= x_pad_l) && (X_BALL_L1 <= x_pad_r) &&  // yatay çarpýþma
    (y_ball_b1 >= y_pad_t) && (y_ball_t1 <= y_pad_b);   // dikey çarpýþma
    
    wire collision2;
    assign collision2 = 
    (X_BALL_R2 >= x_pad_l) && (X_BALL_L2 <= x_pad_r) &&  // yatay çarpýþma
    (y_ball_b2 >= y_pad_t) && (y_ball_t2 <= y_pad_b);   // dikey çarpýþma
    
    wire collision3;
    assign collision3 = 
    (X_BALL_R3 >= x_pad_l) && (X_BALL_L3 <= x_pad_r) &&  // yatay çarpýþma
    (y_ball_b3 >= y_pad_t) && (y_ball_t3 <= y_pad_b);   // dikey çarpýþma
    
    wire collision4;
    assign collision4 = 
    (X_BALL_R4 >= x_pad_l) && (X_BALL_L4 <= x_pad_r) &&  // yatay çarpýþma
    (y_ball_b4 >= y_pad_t) && (y_ball_t4 <= y_pad_b);   // dikey çarpýþma
    
    wire collision5;
    assign collision5 = 
    (X_BALL_R5 >= x_pad_l) && (X_BALL_L5 <= x_pad_r) &&  // yatay çarpýþma
    (y_ball_b5 >= y_pad_t) && (y_ball_t5 <= y_pad_b);   // dikey çarpýþma
    
    
    
    
    //Oyuncu hareketi
    always @* begin
        y_pad_next = y_pad_reg; // Default: paddle hareket etmez
        x_pad_next = x_pad_reg; 
        
        // Harita kontrolü: üst, alt, sað, sol
        if (refresh_tick) begin
            if(collision1 ||collision2 ||collision3 ||collision4 || collision5) begin
                y_pad_next = 360;
                x_pad_next = 16;

            end else begin
                // Yukarý hareket kontrolü
                
                if (up)
                    if((x_pad_reg > 0 && x_pad_reg <= 160 &&  y_pad_reg > 320) || (x_pad_reg >= 160 && x_pad_reg <= 448 && y_pad_reg > 64) || (x_pad_reg >= 448 && y_pad_reg > 320))
                        y_pad_next = y_pad_reg - PAD_VELOCITY;
                   
        
                // Aþaðý hareket kontrolü
                if (down)
                    if ((x_pad_reg > 0 && x_pad_reg <= 224 &&  y_pad_reg < 372)|| (x_pad_reg >= 224 && x_pad_reg <384 && y_pad_reg < 128) || ((x_pad_reg >= 384 && y_pad_reg < 384)))
                        y_pad_next = y_pad_reg + PAD_VELOCITY;
                    
                    
        
                // Sol hareket kontrolü
                if (left)
                    if((y_pad_reg > 64 && y_pad_reg < 320 && x_pad_reg > 160 || x_pad_reg < 160) ||
                        y_pad_reg > 128 && y_pad_reg < 372 && x_pad_reg > 384 ||x_pad_reg <384)
                        
                        x_pad_next = x_pad_reg - PAD_VELOCITY;
                        
                        
        
                // Sað hareket kontrolü
                if (right)  
                    if((y_pad_reg >= 320 && y_pad_reg < 384 && x_pad_reg < 160) || (y_pad_reg < 384 && y_pad_reg > 64 && x_pad_reg > 160 && x_pad_reg < 224) 
                    || (y_pad_reg > 64 && y_pad_reg < 128 && x_pad_reg > 224 && x_pad_reg < 384) || (y_pad_reg > 64 && y_pad_reg < 384 && x_pad_reg > 384 && x_pad_reg < 448)
                    || (y_pad_reg > 320 && y_pad_reg < 384 && x_pad_reg > 448))
                    x_pad_next = x_pad_reg + PAD_VELOCITY;
             end
        end
        
        
        
    end


    
    
    
    
    initial begin
        direction1 = 0;
        direction2 = 1;
    end
    
    
     // Register Control
    always @(posedge clk or posedge reset)
        if(reset) begin
            y_ball_reg1 <= start_y1;
            direction1 <= 0;
            
            y_ball_reg2 <= start_y2;
            direction2 <= 1;
            
            y_ball_reg3 <= start_y3;
        end
        else begin
            y_ball_reg1 <= y_ball_next1;
            direction1 <= direction_next1;
            
            y_ball_reg2 <= y_ball_next2;
            direction2 <= direction_next2;
            
            y_ball_reg3 <= y_ball_next3;
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
        else if (pad_on)
            rgb = pad_rgb; // Paddle rengi
        else if (is_sky)
            rgb = SKY_COLOR; // Gökyüzü rengi
        else
            rgb = sprite_out; // Sprite rengi
    end
    


endmodule