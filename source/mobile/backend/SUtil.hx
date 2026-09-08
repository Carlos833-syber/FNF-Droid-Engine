package mobile.backend;

import haxe.Exception;
import lime.system.System as LimeSystem;
import lime.utils.Log as LimeLogger;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
 * A storage class for mobile.
 */
class SUtil
{
	#if sys
	public static function getStorageDirectory(
		type:StorageType = #if EXTERNAL EXTERNAL #elseif OBB EXTERNAL_OBB #elseif MEDIA MEDIA #else EXTERNAL_DATA #end
	):String
	{
		var daPath:String = '';

		#if android
		/*
		 * Não usamos mais android.content.Context,
		 * android.os.Environment ou AndroidPermissions.
		 *
		 * O Lime já fornece um diretório de armazenamento
		 * próprio para o aplicativo.
		 */
		switch (type)
		{
			case EXTERNAL_DATA:
				daPath = LimeSystem.applicationStorageDirectory;

			case EXTERNAL_OBB:
				daPath = LimeSystem.applicationStorageDirectory;

			case EXTERNAL:
				daPath = LimeSystem.applicationStorageDirectory;

			case MEDIA:
				daPath = LimeSystem.applicationStorageDirectory;
		}
		#elseif ios
		daPath = LimeSystem.documentsDirectory;
		#else
		daPath = LimeSystem.applicationStorageDirectory;
		#end

		return daPath;
	}

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';

		if (directory.length > 0 && directory.substr(0, 1) == '/')
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
			var saveDirectory:String = getStorageDirectory();

			if (!FileSystem.exists(saveDirectory))
				mkDirs(saveDirectory);

			var savesDirectory:String = saveDirectory + '/saves';

			if (!FileSystem.exists(savesDirectory))
				mkDirs(savesDirectory);

			File.saveContent(
				savesDirectory + '/' + fileName + fileExtension,
				fileData
			);

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

	/**
	 * Android permissions.
	 *
	 * O Android moderno não precisa desse sistema antigo
	 * de READ/WRITE_EXTERNAL_STORAGE para o armazenamento
	 * privado do aplicativo.
	 */
	#if android
	public static function doPermissionsShit():Void
	{
		try
		{
			var storage:String = getStorageDirectory();

			if (!FileSystem.exists(storage))
				mkDirs(storage);

			if (!FileSystem.exists(storage))
			{
				showPopUp(
					"Não foi possível criar o diretório de armazenamento.",
					"Erro"
				);
				return;
			}
		}
		catch (e:Dynamic)
		{
			showPopUp(
				"Não foi possível acessar o armazenamento do aplicativo.",
				"Erro"
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
