db = {}
createMongoCollection = (collection) ->
  db[collection] = new Meteor.Collection collection

findOne = (collection, query, fields) -
	db[collection].findOne(query, fields)
