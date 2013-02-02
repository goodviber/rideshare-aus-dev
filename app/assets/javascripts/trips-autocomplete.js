
    


    function getBaseURL()
    {
      var l = window.location;
      var base_url = l.protocol + "//" + l.host + "/" + l.pathname.split('/')[1];
      return base_url;
    }

    /*
    * Autocomplete function to attach to search boxes so that it filters 
    */
    function places_autocomplete (request, response, locale) {
      var service = new google.maps.places.AutocompleteService(null, {types: ['cities'], componentRestrictions: {country: "au"}});
      $.ajax({
        url: getBaseURL() + "/trips/load_events?term=" + request.term, //where is script located 
        success: function( data ) {
          events = eval(data);            
          if (events != null && events.length > 0)
            eventsArray = ["---Events:---"].concat(eval(data));
          else
            eventsArray = [];
          var locationsArray = new Array();
          //get predictions from google maps
          service.getQueryPredictions({input: request.term}, 
              function(predictions, status){
                locationsArray = $.map( 
                  predictions, function( item ) { 
                                    
                                    return {
                                            label: item.description,   
                                            id: item.description,
                                            type: "Location"
                                    };
                                }
                );
                locationsArray = (["---Locations:---"]).concat(locationsArray);
                results = eventsArray.concat(locationsArray);
                
                //send results back to autocomplete
                response(results);
            });
          }
      });
    };
      
