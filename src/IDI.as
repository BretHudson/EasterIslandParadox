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
		public static var achievement1Name:String = 'Halfway There';
		public static var achievement1Key:String = '0a20fafa8f68bef57bb4';
		public static var achievement2Name:String = 'Complete';
		public static var achievement2Key:String = '3d04eef769f3ec0a5bb5';
		
		// Default
		public var idnet;
		private var appID:String = '56e9ef70d55930402f0048cb';// your application id
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
			Security.allowInsecureDomain('*');
			Security.allowDomain('*');
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:Event):void
		{
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
			idnet = e.currentTarget.content;
			idnet.addEventListener('IDNET', handleIDNET);
			stage.addChild(idnet);
			idnet.init(stage, appID, '', verbose, showPreloader, protection);
		}
	}
}