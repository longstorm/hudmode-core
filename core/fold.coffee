### helper to access folds which have foldId as parent. ###
childHash = (foldId) -> '#' + foldId

### helper to access foldId's child at position pos. ###
childAt = (pos, foldId) ->
  chld = {}
  chld[childHash foldId] = pos
  return chld

### query to access folds which have foldId as parent. ###
child = (foldId) ->
  chld = {}
  chld[childHash foldId] = { "$exists": 1 }
  return chld

### query to rescue global orphaned folds. ###
orphan = -> "$or": [
    { parents: "$not": { "$exists": 1 } },
    { parents: "$in": [null, []] }
  ]

### query to access children of foldId positioned after pos. ###
childGt = (foldId, pos) ->
  chld = {}
  chld[childHash foldId] = { "$gt": pos }
  return "$and": [ (child foldId), chld ]

### query to access children of foldId positioned before pos. ###
childLt = (foldId, pos) ->
  chld = {}
  chld[childHash foldId] = { "$lt": pos }
  return "$and": [ (child foldId), chld ]

### helper to sort children of foldId. ###
childSort = (foldId, dir=1) ->
  sorter = sort: {}
  sorter.sort[childHash foldId] = dir
  return sorter

### a Folder is a category of folds, stored in distinct Mongo Collection. ###
class Folder
  constructor: (collection) ->
    @collection = collection
    createMongoCollection collection

  @collection: undefined
    
  ### get a fold by it's id, optionally getting only fields specified. ###
  getById: (id=-1, fields={}) -> findOne collection, _id: id, fields
