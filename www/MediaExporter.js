cordova.define("cordova-plugin-MediaExporter.MediaExporter", function(require, exports, module) {
               
               var argscheck = require('cordova/argscheck'),
               channel = require('cordova/channel'),
               utils = require('cordova/utils'),
               exec = require('cordova/exec'),
               cordova = require('cordova');
               
               channel.createSticky('onCordovaInfoReady');
               // Tell cordova channel to wait on the CordovaInfoReady event
               channel.waitForInitialization('onCordovaInfoReady');
               
               //exports.coolMethod = function(arg0, success, error) {
               //    exec(success, error, "MediaExporter", "coolMethod", [arg0]);
               //};
               
               function MediaExporter() {
               //this.available = false;
               this.title = null;
               this.id = null;
               
               var me = this;
               
               channel.onCordovaReady.subscribe(function() {
                                                me.getInfo(function(info) {
                                                           //ignoring info.cordova returning from native, we should use value from cordova.version defined in cordova.js
                                                           //TODO: CB-5105 native implementations should not return info.cordova
                                                           var buildLabel = cordova.version;
                                                           me.available = true;
                                                           me.title = info.title;
                                                           me.id = info.id;
                                                           
                                                           channel.onCordovaInfoReady.fire();
                                                           },function(e) {
                                                           //me.available = false;
                                                           utils.alert("[ERROR] Error initializing Cordova: " + e);
                                                           });
                                                });
               }
               
               MediaExporter.prototype.getInfo = function(successCallback, errorCallback) {
               argscheck.checkArgs('fF', 'MediaExporter.getInfo', arguments);
               exec(successCallback, errorCallback, "MediaExporter", "getMediaInfo", []);
               };
               
               module.exports = new MediaExporter();
               
               
               });
