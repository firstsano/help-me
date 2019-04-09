const App = {};
App.cable = ActionCable.createConsumer();
App.subscribeOnComments = function(ids, type, callbacks) {
  const channel = 'CommentsChannel';
  if (!_.isArray(ids)) {
    ids = [ids];
  }
  for (id of ids) {
    this.cable.subscriptions.create({
      channel,
      commentable_id: id,
      commentable_type: type
    }, callbacks);
  }
};
