.PHONY : all clean help settings

COUNT=bin/countwords.py
COLLATE=bin/collate.py
DATA=$(wildcard data/*.txt)
PLOT=bin/plotcounts.py
RESULTS=$(patsubst data/%.txt,results/%.csv,$(DATA))

## all : regenerate all results.
all : results/collated.png

## results/collated.png : plot the collated results.
results/collated.png : results/collated.csv bin/plotparams.yml
	python $(PLOT) $< --outfile $@ --plotparams $(word 2,$^)

## results/collated.csv : collate all results.
results/collated.csv : $(RESULTS) $(COLLATE)
	mkdir -p results
	python $(COLLATE) $(RESULTS) > $@

## results/%.csv : regenerate results for any book.
results/%.csv : data/%.txt $(COUNT)
	python $(COUNT) $< > $@

## clean : remove all generated files.
clean : 
	rm $(RESULTS) results/collated.csv results/collated.png

## settings : show variables' values.
settings : 
	@echo COUNT: $(COUNT)
	@echo COLLATE: $(COLLATE)
	@echo DATA: $(DATA)
	@echo PLOT: $(PLOT)
	@echo RESULTS: $(RESULTS)

## help : show this message
help : 
	@grep '^##' ./Makefile