_ = require('underscore')

apiClient = require('./api_client')

class Client
  constructor: (options) ->
    @api = new apiClient.APIClient(options)

  queue: (name) ->
    new Client(_.extend({}, @api.options, {queue_name: name}))

  create_queue: (queue_name, options, cb) ->
    options = prepareQueueOptions(options)
    @api.queuesCreate(queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  update_queue: (queue_name, options, cb) ->
    options = prepareQueueOptions(options)
    @api.queuesUpdate(queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  queues: (options, cb) ->
    @api.queuesList(options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  info: (cb) ->
    @api.queuesGet(@api.options.queue_name, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clear: (cb) ->
    @api.queuesClear(@api.options.queue_name, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  update: (options, cb) ->
    @api.queuesUpdate(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  add_alerts: (alerts, cb) ->
    unless alerts instanceof Array
      alerts = [alerts]
    options = {queue: {alerts: alerts}}

    @api.queuesUpdate(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  clear_alerts: (cb) ->
    options = {queue: {alerts: [{}]}}

    @api.queuesUpdate(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  update_alerts: (alerts, cb) ->
    unless alerts instanceof Array
      alerts = [alerts]

    @api.queuesUpdateAlerts(
      @api.options.queue_name,
    { alerts: alerts },
    (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  delete_alerts: (alerts, cb) ->
    unless alerts instanceof Array
      alerts = [alerts]

    @api.queuesDeleteAlerts(
      @api.options.queue_name,
    { alerts: alerts },
    (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  delete_alert_by_id: (alert_id, cb) ->
    @api.queuesDeleteAlertById(@api.options.queue_name, alert_id, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  add_subscribers: (subscribers, cb) ->
    unless subscribers instanceof Array
      subscribers = [subscribers]

    values = prepareSubscribers(subscribers)
    options = {queue: {push: {subscribers: values }}}

    @api.queuesUpdate(
      @api.options.queue_name, options, (error, body) ->
        if not error?
          cb(error, body)
        else
          cb(error, body)
    )

  clear_subscribers: (cb) ->
    options = {queue: {push: {subscribers: [{}] }}}
    @api.queuesUpdate(
      @api.options.queue_name, options, (error, body) ->
        if not error?
          cb(error, body)
        else
          cb(error, body)
    )

  rm_subscribers: (subscribers, cb) ->
    unless subscribers instanceof Array
      subscribers = [subscribers]

    @api.queuesRemoveSubscribers(
      @api.options.queue_name,
      { subscribers: subscribers },
      (error, body) ->
        if not error?
          cb(error, body)
        else
          cb(error, body)
    )

  del_queue: (cb) ->
    @api.queuesDelete(@api.options.queue_name, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  post: (messages, cb) ->
    unless messages instanceof Array
      messages = [messages]
      
    messages = _.map(messages, (message) ->
      if typeof(message) == 'string' then {body: message} else message
    )

    @api.messagesPost(@api.options.queue_name, messages, (error, body) ->
      if not error?
        cb(error, if messages.length == 1 then body.ids[0] else body.ids)
      else
        cb(error, body)
    )

  get: (options, cb) ->
    @get_n(options, (error, body) ->
      if not error?
        cb(error, if (not options.n?) or options.n == 1 then body[0] else body)
      else
        cb(error, body)
    )

  reserve: (options, cb) ->
    @get_n(options, (error, body) ->
      if not error?
        cb(error, if (not options.n?) or options.n == 1 then body[0] else body)
      else
        cb(error, body)
    )


  get_n: (options, cb) ->
    @api.messagesGet(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body.messages)
      else
        cb(error, body)
    )

  peek: (options, cb) ->
    @peek_n(options, (error, body) ->
      if not error?
        cb(error, if (not options.n?) or options.n == 1 then body[0] else body)
      else
        cb(error, body)
    )

  peek_n: (options, cb) ->
    @api.messagesPeek(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body.messages)
      else
        cb(error, body)
    )

  del: (options, cb) ->
    @api.messagesDelete(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  del_multiple: (options, cb) ->
    ids = prepareIdsToRemove(options)
    @api.messagesMultipleDelete(@api.options.queue_name, ids, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  msg_get: (message_id, cb) ->
    @api.messagesGetById(@api.options.queue_name, message_id, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  msg_touch: (options, cb) ->
    @api.messagesTouch(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  msg_release: (options, cb) ->
    @api.messagesRelease(@api.options.queue_name, options, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  msg_push_statuses: (message_id, cb) ->
    @api.messagesPushStatuses(@api.options.queue_name, message_id, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  del_msg_push_status: (message_id, subscriber_id, cb) ->
    @api.messagesPushStatusDelete(@api.options.queue_name, message_id, subscriber_id, (error, body) ->
      if not error?
        cb(error, body)
      else
        cb(error, body)
    )

  prepareQueueOptions = (options) ->
    body = {}
    if options['message_timeout']
       body['message_timeout'] = options['message_timeout']
    if options['message_expiration']
       body['message_expiration'] = options['message_expiration']
    if options['type']
       body['type'] = options['type']
    if options['alerts']
       body['alerts'] = options['alerts']
    push = {}
    if options['error_queue']
       push['error_queue'] = options['error_queue']
    if options['subscribers']
       push['subscribers'] = prepareSubscribers(options['subscribers'])
    if not _.isEmpty(push)
       body['push'] = push
    queue = {queue: body}
    queue

  prepareIdsToRemove = (options) ->
    body = {}
    if options["ids"]
      body["ids"] = _.map(options["ids"], (val) -> {id: val})
    else if options["reservation_ids"]
      body["ids"] = _.map(options["reservation_ids"], (val) -> {id: val.id, reservation_id: val.reservation_id})
    body

  prepareSubscribers = (subscribers) ->
    values = _.map(subscribers, (val) -> {url: val})
    values

module.exports.Client = Client
