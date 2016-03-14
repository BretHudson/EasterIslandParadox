package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.system.*;
	import net.flashpunk.FP;

	public class IDI extends MovieClip
	{
		
		// Achievements
		public static var achievementOneName:String = 'One';
		public static var achievementOneKey:String = 'b8ae81614151ec4e903a';
		public static var achievementTwoName:String = 'Two';
		public static var achievementTwoKey:String = '52dfe3fa13f64b432ca1';
		public static var achievementThreeName:String = 'THREE';
		public static var achievementThreeKey:String = 'ede426942c1e3f8ad586';
		
		// Default
		public var idnet;
		private var appID:String = '56e6f7a2bbddbd6b5d001127';// your application id
		private var verbose:Boolean = true;// display idnet messages
		private var showPreloader:Boolean = false;// Display Traffic Flux preloader ad
		private var protection:Boolean = false;// Enable information about sites that block links

		// All data is delivered to the handleIDNET function
		private function handleIDNET(e:Event):void
		{
			// uncomment the next 2 lines to see all data
			//log(idnet.type);
			//log(JSON.stringify(idnet.data));
			if (idnet.type == 'login')
			{
				log('hello '+idnet.userData.nickname+' your pid is '+idnet.userData.pid);
			}
			if (idnet.type == 'submit')
			{
				log('data submitted. status is '+idnet.data.status);
			}
			if (idnet.type == 'retrieve')
			{
				if (idnet.data.hasOwnProperty('error') === false)
				{
					log('LOG: data retrieved. key is '+idnet.data.key+' data is '+idnet.data.jsondata);
					var someName:Object = JSON.parse(idnet.data.jsondata);
				}
				else
				{
					log('Error: '+idnet.data.error);
				}
			}
			if (idnet.type == 'delete')
			{
				log('deleted data '+idnet.data);
			}

			if (idnet.type == 'advancedScoreListPlayer')
			{
				log('player score: '+idnet.data.scores[0].points);
			}
			if (idnet.type == 'achievementsSave')
			{
				if (idnet.data.errorcode == 0)
				{
					log('achievement unlocked');
				}
			}
			if (idnet.type == 'mapSave')
			{
				log('map saved. levelid is '+idnet.data.level.levelid);
			}
			if (idnet.type == 'mapLoad')
			{
				log(idnet.data.level.name+' loaded');
			}
			if (idnet.type == 'mapRate')
			{
				log('rating added');
			}
		}

		private function log(message:String):void
		{
			FP.console.log('LOG: ' + message);
		}



		// Below is the loader for the id.net interface. Do Not edit below.
		public function IDI()
		{
			log("HI!");
			Security.allowInsecureDomain('*');
			Security.allowDomain('*');
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:Event):void
		{
			log("Hmmm...");
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			if (Security.sandboxType != "localTrusted")
			{
				loaderContext.securityDomain = SecurityDomain.currentDomain;
			}
			var sdk_url:String = "https://www.id.net/swf/idnet-client.swc?="+new Date().getTime();
			var urlRequest:URLRequest = new URLRequest(sdk_url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
			loader.load(urlRequest, loaderContext);
		}
		private function loadComplete(e:Event):void
		{
			log("LOAD COMPLETE!");
			idnet = e.currentTarget.content;
			idnet.addEventListener('IDNET', handleIDNET);
			stage.addChild(idnet);
			idnet.init(stage, appID, '', verbose, showPreloader, protection);
		}
	}
}