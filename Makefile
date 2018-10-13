
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # vanilla, but with --environ

sandbox.html: sandbox.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox.Rmd')"

sandbox-freeze.html: sandbox-freeze.Rmd sandbox-simplemodel.html
	R ${R_OPTS} -e "rmarkdown::render('sandbox-freeze.Rmd')"

sandbox-simplemodel.html: sandbox-simplemodel.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox-simplemodel.Rmd')"
