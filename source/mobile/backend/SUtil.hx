package mobile.backend;

import haxe.Exception;
import lime.system.System as LimeSystem;
import lime.utils.Log as LimeLogger;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class SUtil
{
	#if sys

	public static function getStorageDirectory(
		type:StorageType = #if EXTERNAL EXTERNAL #elseif OBB EXTERNAL_OBB #elseif MEDIA MEDIA #else EXTERNAL_DATA #end
	):String
	{
		#if android
		return LimeSystem.applicationStorageDirectory;
		#elseif ios
		return LimeSystem.documentsDirectory;
		#else
		return LimeSystem.applicationStorageDirectory;
		#end
	}

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';

		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');

		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				if (!FileSystem.exists(total))
					FileSystem.createDirectory(total);
			}
		}
	}

	public static function saveContent(
		fileName:String = 'file',
		fileExtension:String = '.json',
		fileData:String = 'you forgot to add something in your code :3'
	):Void
	{
		try
		{
			var saveDirectory:String = getStorageDirectory() + '/saves';

			if (!FileSystem.exists(saveDirectory))
				mkDirs(saveDirectory);

			var filePath:String =
				saveDirectory + '/' + fileName + fileExtension;

			File.saveContent(filePath, fileData);

			showPopUp(
				fileName + " file has been saved.",
				"Success!"
			);
		}
		catch (e:Exception)
		{
			LimeLogger.println(
				"File couldn't be saved.\n(" + e.message + ")"
			);
		}
	}

	#end

	#if android

	public static function doPermissionsShit():Void
	{
		try
		{
			var directory:String = getStorageDirectory();

			if (!FileSystem.exists(directory))
				mkDirs(directory);
		}
		catch (e:Dynamic)
		{
			LimeLogger.println(
				"Could not create application storage directory."
			);
		}
	}

	#end

	public static function showPopUp(
		message:String,
		title:String
	):Void
	{
		#if (windows || web || android || ios)
		openfl.Lib.application.window.alert(message, title);
		#else
		LimeLogger.println('$title - $message');
		#end
	}
}

enum StorageType
{
	EXTERNAL;
	EXTERNAL_DATA;
	EXTERNAL_OBB;
	MEDIA;
}
