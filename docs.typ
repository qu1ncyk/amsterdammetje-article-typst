#import "@preview/tidy:0.4.2"
#import "@preview/amsterdammetje-article:0.1.1": heading-author

= Amsterdammetje Article
(Unofficial) Typst rewrite of
#link("https://www.overleaf.com/latex/templates/uva-informatica-template-artikel/dsjkstcpphny")[LaTeX article template]
used in the BSc Computer Science of the University of Amsterdam.
Source code available at https://github.com/qu1ncyk/amsterdammetje-article-typst.

#v(2em)

// Tinymist only supports the old syntax
#let docs = tidy.parse-module(read("lib.typ"), old-syntax: true)
#tidy.show-module(docs, style: tidy.styles.default)
