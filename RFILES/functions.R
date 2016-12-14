library(ggplot2)
library(Hmisc)
dvipng.dvi <-
  function (object, file, ...) 
  {
    cmd <- if (missing(file)) 
      paste("dvipng -T tight", shQuote(object$file))
    else paste("dvipng -T tight", "-o", file, shQuote(object$file))
    invisible(sys(cmd))
  }

themeLine2 <- theme_grey()+
  theme(panel.background=element_blank(),
        axis.title=element_text(color='Grey',
                                vjust=-.5,
                                face='bold'),
        panel.grid.major.y=
          element_line(linetype='dotted',
                       color='Grey'),
        axis.line=element_line(linetype='dashed',
                               color='Grey'))
