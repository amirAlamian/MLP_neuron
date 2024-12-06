module Controller #(
    parameter num_address = 512,
    parameter weight_bit = 32
)(
    input clk,
    input reset,
    input start,
    output reg mux_select,
    output reg demux_select,
    output reg read_enable,
    output reg write_enable,
    output reg [num_address-1:0] sram1_address,
    output reg [num_address-1:0] sram2_address,
    output reg done
);

    typedef enum logic [2:0] {
        idle,
        read_weight,
        read_input,
        compute,
        write_output,
        done_state
    } state_t;

    state_t current_state, next_state;

    reg [num_address-1:0] addr_counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= idle;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin
        next_state = current_state;
        mux_select = 0;
        demux_select = 0;
        read_enable = 0;
        write_enable = 0;
        sram1_address = 0;
        sram2_address = 0;
        done = 0;

        case (current_state)
            idle: begin
                if (start) begin
                    next_state = read_weight;
                end
            end

            read_weight: begin
                read_enable = 1;
                sram1_address = addr_counter;
                next_state = read_input;
            end

            read_input: begin
                read_enable = 1;
                sram2_address = addr_counter;
                next_state = compute;
            end

            compute: begin
                mux_select = 1;
                demux_select = 1;
                next_state = write_output;
            end

            write_output: begin
                write_enable = 1;
                next_state = done_state;
            end

            done_state: begin
                done = 1;
                next_state = idle; 
            end
        endcase
    end

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            addr_counter <= 0;
        end else if (current_state == write_output) begin
            addr_counter <= addr_counter + 1;
        end
    end

endmodule