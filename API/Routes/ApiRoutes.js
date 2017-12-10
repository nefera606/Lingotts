'use strict';
module.exports = function(app) {
  var userController = require('../Controllers/UserController');

  app.route('/users')
    .get(userController.list_all_users)
    .post(userController.create_a_user);

  app.route('/isUser/:UserName')
    .get(userController.is_a_user);

  app.route('/users/:UserName')
    .get(userController.list_a_user)
    .delete(userController.delete_a_user);

};
