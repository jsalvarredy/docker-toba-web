# Default Apache virtualhost template

<VirtualHost *:80>
    ServerAdmin {{ apache.serveradmin }}
    ServerName {{ apache.servername }}
    Serveralias {{ apache.serveralias }}
    DocumentRoot {{ apache.docroot }}

    <Directory {{ apache.docroot }}>
        AllowOverride All
        Options -Indexes +FollowSymLinks
        Require ip {{ apache.allowfrom }}
    </Directory>
    
    Alias /{{apache.apptoba}}_toba {{ apache.pathtoba }}/toba/www
    <Directory "{{ apache.pathtoba }}/toba/www/">
        SetEnv TOBA_DIR       {{ apache.pathtoba }}/toba
        Options MultiViews
        AllowOverride All
        Require ip {{ apache.allowfrom }}
    </Directory>

	#Proyecto: toba_usuarios
	Alias /{{apache.apptoba}}_toba_usuarios "{{apache.pathtoba}}/toba/proyectos/toba_usuarios/www"
	<Directory "{{apache.pathtoba}}/toba/proyectos/toba_usuarios/www/">
		DirectoryIndex aplicacion.php
		Options MultiViews
        	AllowOverride All
        	Require ip {{ apache.allowfrom }}
		SetEnv TOBA_DIR 		"{{apache.pathtoba}}/toba"
		SetEnv TOBA_PROYECTO 	"toba_usuarios"		
		SetEnv TOBA_INSTANCIA	{{ apache.tobainstancia }}
		SetEnv TOBA_INSTALACION_DIR "{{apache.pathtoba}}/instalacion"
	</Directory>


	#Proyecto: {{apache.apptoba}}
	Alias /{{apache.apptoba}} "{{apache.pathtoba}}/aplicacion/www"
	<Directory "{{apache.pathtoba}}/aplicacion/www/">
		DirectoryIndex aplicacion.php
		Options MultiViews
        	AllowOverride All
        	Require ip {{ apache.allowfrom }}
		SetEnv TOBA_DIR 		"{{apache.pathtoba}}/toba"
		SetEnv TOBA_PROYECTO 	"{{apache.apptoba}}"
		SetEnv TOBA_INSTANCIA	"{{apache.tobainstancia}}"
		SetEnv TOBA_INSTALACION_DIR "{{apache.pathtoba}}/instalacion"
	</Directory>

	ErrorLog {{apache.pathlog}}/{{apache.apptoba}}-error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn
	CustomLog {{apache.pathlog}}/{{apache.apptoba}}-access.log combined
</VirtualHost>
