// ~/.finicky.js


function switchHTTPS(url) {
	const exclusions = [
		'localhost',
		'127.0.0.1',
		'192.168.244.63',
		'192.168.1.17'
		
	]
	
	if (url.protocol !== 'http') return false;
	
	return url.protocol === "http" && exclusions.some( el => url.host.indexOf(el) > - 1) ? false : true;
	
}

module.exports = {
  defaultBrowser: "Safari",
//   defaultBrowser: "Arc",
  rewrite: [  
    {
      // Redirect all urls to use https
      match: ({ url }) => switchHTTPS(url),
      url: { protocol: "https" }
    },
    {
      match: () => true, // Execute rewrite on all incoming urls to make this example easier to understand
      url({ url }) {
        const removeKeysStartingWith = ["utm_", "uta_"]; // Remove all query parameters beginning with these strings
        const removeKeys = ["fbclid", "gclid"]; // Remove all query parameters matching these keys

        const search = url.search
          .split("&")
          .map((parameter) => parameter.split("="))
          .filter(([key]) => !removeKeysStartingWith.some((startingWith) => key.startsWith(startingWith)))
          .filter(([key]) => !removeKeys.some((removeKey) => key === removeKey));

        return {
          ...url,
          search: search.map((parameter) => parameter.join("=")).join("&"),
        };
      },
    }    
  ],
  handlers: [
    {
      match: [
        /cxone/,
        "192.168.244.63*",
		"192.*",
        "tlvjira*",
        "tlvconfluence*",
        "nice-identity*",
        "niceonline-my.sharepoint.com*",
        "selfservice.devops.niceincontact.com*",
        "dlmanager.nice.com*",
        "storefront.nice.com*",
        "*niceincontact.com*",
        "*nice.com*",        
        "*nice-incontact.com*",
        /powerbi.com/,
        /nicensc.satmetrix.com/,
        "*vehicleordertracking*",
        /teams\.microsoft\.com/,
        /outlook\.office\.com/,
        "*localhost*",
        "127.0.0.1*",
        ({ url }) => url.protocol === 'file:'
      ],
      browser: "Google Chrome"
    },
    {
      // Open any url that includes the string "workplace" in Firefox
      match: /cxone/,
      browser: "Google Chrome"
    },    
    {
      // Open any url that includes the string "workplace" in Firefox
      match: [
      	"outlook.office.com",
      	"teams.microsoft.com"
      ],
      browser: "Firefox Developer Edition"
    },
    {
      // Open google.com and *.google.com urls in Google Chrome
      match: [
        "google.com*", // match google.com urls
        finicky.matchDomains(/.*\.google.com/) // use helper function to match on domain only
      ],
      browser: "Google Chrome"
    },
	{
	  match: "https://www.figma.com/file/*",
	  browser: "Figma"
	}    
  ]
};
