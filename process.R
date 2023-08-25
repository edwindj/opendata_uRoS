library(jsonlite)
library(DiagrammeR)
library(DiagrammeRsvg)

graph <- read_json("./graph.json", simplifyVector = TRUE)

nodes <- graph$nodes
links <- graph$links

links_mmd <- paste( links$source |> gsub("\\W", "_", x = _)
                  , "-->"
                  , links$target |> gsub("\\W", "_", x = _)
)

writeLines(c(
"graph LR",
"",
links_mmd),
con = "test.mmd"
)

use_quotes <- function(x){
  paste0('"', x, '"')
}

links_dot <- paste( links$source |> use_quotes()
                 , "->"
                 , links$target |> use_quotes()
                 , ";"
)

nt <- with(nodes, {split(name, type)})

nodes_dot <- lapply(names(nt), function(nm){
  n <- nt[[nm]]
  c( paste0("// ", nm),
   "{ rank=same;",
   paste(use_quotes(n), collapse = ";"),
   "}")
}) |> unlist()

c(
  "digraph G {",
  "rankdir=LR;",
  nodes_dot,
  "",
  links_dot,
  "}"
) |>
  writeLines("test.dot")

DiagrammeR::grViz("test.dot")
