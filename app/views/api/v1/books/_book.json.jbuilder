json.id book.id
json.author book.author
json.title book.title
json.category do
  json.partial! book.category, as: :category
end
