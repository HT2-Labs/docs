---
---

# Query (Analytics) API

The purpose of this custom API is to provide developers building reporting type tools with a few additional views of the data within an LRS.

Method | HTTP request | Description
--- | --- | ---
[analytics](#analytics) | GET /analytics | Gets a paginated list of statements that match given filters.

*URIs relative to http://www.example.com/api/v1/query/, unless otherwise noted. Additionally you must supply your Basic Auth details with each request. Your Basic Auth details can be found under "xAPI Statements" in your LRS's settings.*

## analytics
```
GET http://www.example.com/api/v1/query/analytics
```

### Parameters

Name | Type | Description
--- | --- | ---
**filter** | Object | The filters that the statements must pass.
type | QueryType | Type of grouping applied (defaults to "time").
interval | QueryInterval | Time grouping, only applicable when `type` = time (defaults to "day").
since | QueryDate | Date to begin returning statements.
until | QueryDate | Date to stop returning statements.

*Required parameters are shown in __bold__.*

### Example

    GET http://www.example.com/api/v1/query/analytics?type=time&interval=day&since=2015-01-01&until=2015-01-02&filter={
      "context.contextActivities.grouping.type": "course",
      "object.definition.type": "http://activitystrea.ms/schema/1.0/badge",
      "context.contextActivities.grouping.tags": [
        ['foo', 'bar'], 
        'hello',
        'world'
      ],
      "result.score.raw": ['<>', 0.6, 0.8]
    }

- [About](#about)
- [Analytics](#analytics)
- [Other parameters](#params)

## Parameter Types
### QueryType
String containing either:

- "time": return an array of dates with a count for how many filtered statements occurred in a defined interval  (day, week, month, year)
- "user": return an array of actors with a count for how many filtered statements occurred for each activity: return an array of activities with a count for how many filtered statements occurred for each 
- "verb": return an array of verbs with a count for how many filtered statements occurred for each

### QueryInterval
String containing either:

- "day"
- "week"
- "month"
- "year"

### QueryDate
String of the form YYYY-MM-DD.
