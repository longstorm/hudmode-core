childHash = (foldId) -> '#' + foldId
childAt = (pos, foldId) ->
  chld = {}
  chld[childHash foldId] = pos
  return chld
child = (foldId) ->
  chld = {}
  chld[childHash foldId] = { ["$exists"]: 1 }
  return chld
orphan = -> ["$or"]: [
    { parents: ["$not"]: { ["$exists"]: 1 } },
    { parents: ["$in"]: [null, []] }
  ]
childGt = (foldId, pos) ->
  chld = {}
  chld[childHash foldId] = { ["$gt"]: pos }
  return ["$and"]: [ (child foldId), chld ]
childLt = (foldId, pos) ->
  chld = {}
  chld[childHash foldId] = { ["$lt"]: pos }
  return ["$and"]: [ (child foldId), chld ]
childSort = (foldId, dir=1) ->
  sorter = sort: {}
  sorter.sort[childHash foldId] = dir
  return sorter

getFoldById = (id=-1, fields={}) -> findOne 'folds', _id: id, fields
