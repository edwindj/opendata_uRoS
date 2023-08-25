library(jsonlite)
library(data.table)
library(ggplot2)

graph <- read_json("./data/graph.json", simplifyVector = TRUE)

nodes <- graph$nodes |> as.data.table()
links <- graph$links |> as.data.table()

setkey(nodes, name)

nt <- split(nodes$name, nodes$type)

pkg_api_links <- links[source %in% nt$software, ]
pkg_api_links[ target %in% nt$data_provider, target := "direct"]

pkg_api_links |>
 ggplot(aes(x = target, y = source, fill = target)) + geom_tile() +
  theme_minimal() +
  labs(fill = "API", x = "", y = "", title = "R package vs API")

ggsave("pkg_api.png")
