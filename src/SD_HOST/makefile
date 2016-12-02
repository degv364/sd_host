all:

start_detect:
	iverilog -o start_detect_tb.x start_detect_tb.v -I ..
	./start_detect_tb.x
	gtkwave start_detect_tb.vcd


clean:
	rm *.x *.vcd
