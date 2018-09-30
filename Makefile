
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # vanilla, but with --environ

sandbox.html: sandbox.Rmd
	R ${R_OPTS} -e "rmarkdown::render('sandbox.Rmd')"
