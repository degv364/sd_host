
all: zip

reporte:
	pdflatex reporte.tex
	pdflatex reporte.tex
	pdflatex reporte.tex

simple_synthesis:
	yosys simple_yosys_script.ys
	mv synth.v counters/

cmos_synthesis:
	yosys yosys_script.ys
	mv synth.v counters/

delay_synthesis:
	yosys delay_yosys_script.ys
	mv synth.v counters/

nodelay:
#	cp definitions_4_bit.v definitions.v	
	iverilog -o test_bench  test_bench.v libs/cmos_cells.v
	./test_bench
#	gtkwave test.vcd gtks/delays.gtkw


delay:
#	cp definitions_delay.v definitions.v
	iverilog -o test_bench  test_bench_delay.v libs/cmos_cells_delay.v
	./test_bench
	gtkwave test.vcd gtks/delays.gtkw

power:
	iverilog -o test_bench test_bench_power.v libs/cmos_cells_power.v
	./test_bench

4_bit_simulation:
#	cp definitions_4_bit.v definitions.v
	iverilog -o test_4_bit test_bench_4_bits.v
	./test_4_bit
	gtkwave test.vcd gtks/4_bit_simulation.gtkw

zip: reporte
	zip -r B42781.zip makefile *.v *.gtkw  reporte.pdf reporte.tex modules/ gates/ counters/ gtks/ Hojas_del_fabricante/ libs/ figures/ *.ys

clean:
	rm *~ test.vcd test_bench *.log *.aux *.pdf *.vcd test_4_bit counters/synth.v
