module RemoteForgeryProtection
  JS_FILE_NAME = "remote_forgery_protection.js"
  JS_FILE_PATH = "public/javascripts/#{JS_FILE_NAME}"
    
  class << self
    
    def javascript_code
      %{
// Adds authenticity token to all Ajax requests. 
Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap(function() {
  var args = $A(arguments), proceed = args.shift();
  args[0] = args[0] || {};
  var options = args[0];
  if (!(options.method && options.method.toUpperCase() == "GET")) {
    var encodedToken = encodeURIComponent(_token);
    if (Object.isString(options.parameters)) {
      options.parameters += '&authenticity_token=' + encodedToken;
    } else if (Object.isHash(options.parameters)) {
      options.parameters = options.parameters.toObject();
      options.parameters.authenticity_token = encodedToken;
    } else {
      options.parameters = options.parameters || {};
      options.parameters.authenticity_token = encodedToken;
    }
  }
  proceed.apply(null, args);
});        
      }
    end
    
  end
  
end
