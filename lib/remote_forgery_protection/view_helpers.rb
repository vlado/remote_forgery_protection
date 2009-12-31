module RemoteForgeryProtection  
  module ViewHelpers    
    
    def remote_forgery_protection
      javascript_tag javascript_code_for_rfp
    end 
    
    def token_for_rfp
      "window._token = '#{form_authenticity_token}';"
    end

    def javascript_code_for_rfp
      %{
        #{token_for_rfp}

        Ajax.Base.prototype.initialize = Ajax.Base.prototype.initialize.wrap(function() {
          var args = $A(arguments), proceed = args.shift();
          args[0] = args[0] || {};
          var options = args[0];
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
          proceed.apply(null, args);
        });
      }
    end   
    
  end  
end