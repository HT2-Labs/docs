---
---

# Aggregation HTTP Interface

The Learning Locker Aggregation HTTP interface utilises the [Mongo aggregation API](https://docs.mongodb.com/manual/aggregation/) and is only available for statements. You must additionally supply your Basic Auth details with each request in the `Authorization` header. Your Basic Auth details can be found under Settings > Clients. The interface requires a `pipeline` URL parameter, which is a JSON encoded array containing a pipeline of stages for statements to pass through before being output from the interface. The optional URL parameters are described in the table below.

Name | Description
--- | ---
cache | Boolean that determines if the result should be cached for reuse next time the pipeline is used.
maxTimeMS | Number that specifies the time limit for the query in Mongo.
maxScan | Number that specifies the maximum number of models to scan in Mongo.

A simple request to this interface using all of the available URL parameters looks like the request below. 

```http
GET http://www.example.org/api/statements/aggregate?cache=false&maxTimeMS=5000&maxScan=10000&pipeline=%5B%7B%22%24limit%22%3A%201%7D%2C%20%7B%22%24project%22%3A%20%7B%20%22statement%22%3A%201%2C%20%22_id%22%3A%200%20%7D%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

In the request above, the `pipeline` contains two stages, one to limit the route to returning a max of 1 statement and another to only project the `statement` from the statement's model. The JSON encoded `pipeline` without URL encoding is shown below.

```json
[{"$limit": 1}, {"$project": { "statement": 1, "_id": 0 }}]
```

A response to this valid request will return a 200 response like the response below, where the JSON encoded body contains an array of records.

```http
HTTP/1.1 204 NO CONTENT
Content-Type: application/json; charset=utf-8

[{
  "statement": {
    "id": "dfb7218c-0fc9-4dfc-9524-d497097de027",
    "actor": { "objectType": "Agent", "mbox": "mailto:test@example.org" },
    "verb": { "id": "http://www.example.org/verb" },
    "object": { "objectType": "Activity", "id": "http://www.example.org/activity" },
    "version": "1.0.3",
    "authority": { "objectType": "Agent", "mbox": "mailto:authority@example.org" },
    "timestamp": "2017-09-05T12:45:31+00:00",
    "stored": "2017-09-05T12:45:31+00:00"
  }
}]
```

## Pipeline Stages
So far we've only seen the `limit` and `project` stages, however, there are many other [stages available in Mongo](https://docs.mongodb.com/manual/reference/operator/aggregation-pipeline/). The common stages are listed in the table below.

Name | Description
--- | ---
[project](#project-stage) | Reshapes the records from the previous stage of the pipeline for the next stage.
[match](#match-stage) | Filters the records from the previous stage of the pipeline for the next stage.
[limit](#limit-stage) | Limits the number of records from the previous stage of the pipeline for the next stage.
[skip](#skip-stage) | Skips a number of records from the previous stage of the pipeline for the next stage.
[group](#group-stage) | Groups records by a specified identifier from the previous stage of the pipeline for the next stage.
[sort](#sort-stage) | Sorts the records from the previous stage of the pipeline for the next stage.

### Project Stage
For example, to project the actor's account name as a user's identifier, the verb without a display, and the object's identifier you can use the following project stage.

```json
{
  "userId": "$statement.actor.account.name",
  "statement.verb": {
    "display": 0
  },
  "statement.object.id": 1
}
```

In the example above, the value `0` is used to exclude the verb's display property. Similarly, the value `1` is used to include the object's identifier. You can find out more about the [project stage via the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/project/). The request below demonstrates how the project stage above could be used in a request.

```http
GET http://www.example.org/api/statements/aggregate?pipeline=%5B%7B%0D%0A%20%20%22%24project%22%3A%20%7B%0D%0A%20%20%20%20%22userId%22%3A%20%22%24statement.actor.account.name%22%2C%0D%0A%20%20%20%20%22statement.verb%22%3A%20%7B%0D%0A%20%20%20%20%20%20%22display%22%3A%200%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%22statement.object.id%22%3A%201%0D%0A%20%20%7D%0D%0A%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

### Match Stage
For example, to filter statements by actor or verb, you can use the following match stage.

```json
{
  "$or": [{
    "statement.actor.account.name": "123",
    "statement.actor.account.homePage": "http://www.example.org/user"
  }, {
    "statement.verb.id": {
      "$in": [
        "http://www.example.org/verb",
        "http://www.example.org/otherverb"
      ]
    }
  }]
}
```

In the example above, `$or` and `$in` are operators, all operators start with a dollar (`$`). You can find a [list of the available operators in the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/query/). The most common operators are the comparision operators and the logical operators listed in the table below.

Operator | Description
--- | ---
[`$gt`](https://docs.mongodb.com/manual/reference/operator/query/gt/#op._S_gt) | Includes values greater than a specified value.
[`$gte`](https://docs.mongodb.com/manual/reference/operator/query/gte/#op._S_gte) | Includes values greater than or equal to a specified value.
[`$in`](https://docs.mongodb.com/manual/reference/operator/query/in/#op._S_in) | Includes values that are in the specified values.
[`$lt`](https://docs.mongodb.com/manual/reference/operator/query/lt/#op._S_lt) | Includes values less than a specified value.
[`$lte`](https://docs.mongodb.com/manual/reference/operator/query/lte/#op._S_lte) | Includes values less than or equal to a specified value.
[`$ne`](https://docs.mongodb.com/manual/reference/operator/query/ne/#op._S_ne) | Includes values not equal to a specified value.
[`$nin`](https://docs.mongodb.com/manual/reference/operator/query/nin/#op._S_nin) | Includes values not in the specified values.
[`$and`](https://docs.mongodb.com/manual/reference/operator/query/and/#op._S_and) | Includes values where all specified expressions are true.
[`$not`](https://docs.mongodb.com/manual/reference/operator/query/not/#op._S_not) | Includes values where a specified expression is not true.
[`$nor`](https://docs.mongodb.com/manual/reference/operator/query/nor/#op._S_nor) | Includes values where no specified expressions are true.
[`$or`](https://docs.mongodb.com/manual/reference/operator/query/or/#op._S_or) | Includes values where some specified expressions are true.

You can find out more about the [match stage via the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/match/). The request below demonstrates how the match stage above could be used in a request.

```http
GET http://www.example.org/api/statements/aggregate?pipeline=%5B%7B%0D%0A%20%20%22%24match%22%3A%20%7B%0D%0A%20%20%20%20%22%24or%22%3A%20%5B%7B%0D%0A%20%20%20%20%20%20%22statement.actor.account.name%22%3A%20%22123%22%2C%0D%0A%20%20%20%20%20%20%22statement.actor.account.homePage%22%3A%20%22http%3A%2F%2Fwww.example.org%2Fuser%22%0D%0A%20%20%20%20%7D%2C%20%7B%0D%0A%20%20%20%20%20%20%22statement.verb.id%22%3A%20%7B%0D%0A%20%20%20%20%20%20%20%20%22%24in%22%3A%20%5B%0D%0A%20%20%20%20%20%20%20%20%20%20%22http%3A%2F%2Fwww.example.org%2Fverb%22%2C%0D%0A%20%20%20%20%20%20%20%20%20%20%22http%3A%2F%2Fwww.example.org%2Fotherverb%22%0D%0A%20%20%20%20%20%20%20%20%5D%0D%0A%20%20%20%20%20%20%7D%0D%0A%20%20%20%20%7D%5D%0D%0A%20%20%7D%0D%0A%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

### Limit Stage
For example, to limit the interface to returning 1 statement, you can use the following request. You can find out more about the [limit stage via the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/limit/).

```http
GET http://www.example.org/api/statements/aggregate?pipeline=%5B%7B%20%22%24limit%22%3A%201%20%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

### Skip Stage
For example, to skip the first statement, you can use the following request. You can find out more about the [skip stage via the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/skip/).

```http
GET http://www.example.org/api/statements/aggregate?pipeline=%5B%7B%20%22%24skip%22%3A%201%20%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

### Group Stage
For example, to retrieve the average raw score for each actor, you can use the group stage below.

```json
{
  "_id": {
    "actor_account_homePage": "$statement.actor.account.homePage",
    "actor_account_name": "$statement.actor.account.name",
    "actor_mbox": "$statement.actor.mbox",
    "actor_mbox_sha1sum": "$statement.actor.mbox_sha1sum",
    "actor_openid": "$statement.actor.openid",
  },
  "statements": { "$avg": "$statement.result.score.raw" }
}
```

In the group stage above, the `_id` property specifies the properties to group by and is a required property in the group stage. The rest of the properties in the group stage specify the properties to be passed through to the next stage. In the example above, `$avg` is one of the accumulator operators available in Mongo, the other common accumulator operators are listed in the table below.

Name | Description
--- | ---
[`$sum`](https://docs.mongodb.com/manual/reference/operator/aggregation/sum/#grp._S_sum) | Returns a sum of numeric values from the grouped records.
[`$avg`](https://docs.mongodb.com/manual/reference/operator/aggregation/avg/#grp._S_avg) | Returns an average of numeric values from the grouped records.
[`$first`](https://docs.mongodb.com/manual/reference/operator/aggregation/first/#grp._S_first) | Returns a value from the first record in the grouped records.
[`$last`](https://docs.mongodb.com/manual/reference/operator/aggregation/last/#grp._S_last) | Returns a value from the last record in the grouped records.
[`$max`](https://docs.mongodb.com/manual/reference/operator/aggregation/max/#grp._S_max) | Returns the highest of the numeric values from the grouped records.
[`$min`](https://docs.mongodb.com/manual/reference/operator/aggregation/min/#grp._S_min) | Returns the lowest of the numeric values from the grouped records
[`$push`](https://docs.mongodb.com/manual/reference/operator/aggregation/push/#grp._S_push) | Returns an array of values from the grouped records.
[`$addToSet`](https://docs.mongodb.com/manual/reference/operator/aggregation/addToSet/#grp._S_addToSet) | Returns an array of unique values from the grouped records.

You can find out more about the [group stage via the Mongo documentation](https://docs.mongodb.com/manual/reference/operator/aggregation/group/). The request below demonstrates how the group stage above could be used in a request.

```http
GET http://www.example.org/api/statements/aggregate?pipeline=%5B%7B%0D%0A%20%20%22%24group%22%3A%20%7B%0D%0A%20%20%20%20%22_id%22%3A%20%7B%0D%0A%20%20%20%20%20%20%22actor_account_homePage%22%3A%20%22%24statement.actor.account.homePage%22%2C%0D%0A%20%20%20%20%20%20%22actor_account_name%22%3A%20%22%24statement.actor.account.name%22%2C%0D%0A%20%20%20%20%20%20%22actor_mbox%22%3A%20%22%24statement.actor.mbox%22%2C%0D%0A%20%20%20%20%20%20%22actor_mbox_sha1sum%22%3A%20%22%24statement.actor.mbox_sha1sum%22%2C%0D%0A%20%20%20%20%20%20%22actor_openid%22%3A%20%22%24statement.actor.openid%22%2C%0D%0A%20%20%20%20%7D%2C%0D%0A%20%20%20%20%22statements%22%3A%20%7B%20%22%24avg%22%3A%20%22%24statement.result.score.raw%22%20%7D%0D%0A%20%20%7D%0D%0A%7D%5D
Authorization: Basic YOUR_BASIC_AUTH
```

