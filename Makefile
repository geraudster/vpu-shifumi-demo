
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # vanilla, but with --environ

.PHONY: target

target:
	mkdir -p target

target/sandbox.html: target sandbox.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox.Rmd', output_dir = 'target/')"

target/sandbox-freeze.html: target sandbox-freeze.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox-freeze.Rmd', output_dir = 'target/')"

target/sandbox-simplemodel.html: target sandbox-simplemodel.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox-simplemodel.Rmd', output_dir = 'target/')"

target/slides.html: target slides.Rmd
	R ${R_OPTS} -e "rmarkdown::render('slides.Rmd', output_dir = 'target/')"
