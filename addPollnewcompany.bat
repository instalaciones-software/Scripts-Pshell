@echo --------------------------------------------------------------------------- 
@echo ******************* AGREGAR POOL DE APLICACIONES *******************
@echo ******** USTED VA AGREGAR EL POOL DE APLICACIONES Y EL RECURSO VIRTUAL **************
@echo ** POR FAVOR VERIFICAR LAS RUTAS SI ESTAS ESTAN LIGADAS AL SITIO WEB QUE DESEA CONFIGURAR **
@echo ___________________________________________________________________________
@echo               ===============================================
@echo **************          A D D - P O O L - I I S             **************
@echo               ===============================================
@echo               ===============================================
@echo **************   A D D -  V I R T U A L - R E S O U R C E    **************
@echo               ===============================================


@REM AGREGAR EN LA VARIABLE DE SISTEMA, PATH DE WINDOWS AGREGAR LA RUTA 'C:\Windows\System32\inetsrv\'

appcmd add app /site.name:"prueba2" /path:"/GestionCapitalHumano.Api" /physicalPath:"C:\inetpub\prueba2\GestionCapitalHumano.Api" /applicationPool:"prueba2.GestionCapitalHumano" && appcmd add apppool /apppool.name:prueba2.GestionCapitalHumano /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/GestionCapitalHumano.api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"prueba2" /path:"/Encuestas.Api" /physicalPath:"C:\inetpub\prueba2\Encuestas.Api" /applicationPool:"prueba2.Encuestas" && appcmd add apppool /apppool.name:prueba2.Encuestas /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Encuestas.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/GestionContenidos.Api" /physicalPath:"C:\inetpub\prueba2\GestionContenidos.Api" /applicationPool:"prueba2.GestionContenidos" && appcmd add apppool /apppool.name:prueba2.GestionContenidos /processModel.identityType:"LocalSystem"  && appcmd add vdir /app.name:prueba2/GestionContenidos.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"prueba2" /path:"/ActivosFijos.Api" /physicalPath:"C:\inetpub\prueba2\ActivosFijos.Api" /applicationPool:"prueba2.ActivosFijos" && appcmd add apppool /apppool.name:prueba2.ActivosFijos /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/ActivosFijos.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt

appcmd add app /site.name:"prueba2" /path:"/Admin.Api" /physicalPath:"C:\inetpub\prueba2\Admin.Api" /applicationPool:"prueba2.Admin" && appcmd add apppool /apppool.name:prueba2.Admin /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Admin.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"prueba2" /path:"/ComprasInventarios.Api" /physicalPath:"C:\inetpub\prueba2\ComprasInventarios.Api" /applicationPool:"prueba2.ComprasInventarios" && appcmd add apppool /apppool.name:prueba2.ComprasInventarios /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/ComprasInventarios.api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"prueba2" /path:"/CuentasPorCobrar.Api" /physicalPath:"C:\inetpub\prueba2\CuentasPorCobrar.Api" /applicationPool:"prueba2.CuentasPorCobrar" && appcmd add apppool /apppool.name:prueba2.CuentasPorCobrar /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/CuentasPorCobrar.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/CuentasPorPagar.Api" /physicalPath:"C:\inetpub\prueba2\CuentasPorPagar.Api" /applicationPool:"prueba2.CuentasPorPagar" && appcmd add apppool /apppool.name:prueba2.CuentasPorPagar /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/CuentasPorPagar.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/EntregaMasivaDocumentos.Api" /physicalPath:"C:\inetpub\prueba2\EntregaMasivaDocumentos.Api" /applicationPool:"prueba2.EntregaMasivaDocumentos" && appcmd add apppool /apppool.name:prueba2.EntregaMasivaDocumentos  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/EntregaMasivaDocumentos.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/FacturacionPeriodica.Api" /physicalPath:"C:\inetpub\prueba2\FacturacionPeriodica.Api" /applicationPool:"prueba2.FacturacionPeriodica" && appcmd add apppool /apppool.name:prueba2.FacturacionPeriodica  /processModel.identityType:"LocalSystem" & appcmd add vdir /app.name:prueba2/FacturacionPeriodica.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/Financiero.Api" /physicalPath:"C:\inetpub\prueba2\Financiero.Api" /applicationPool:"prueba2.Financiero" && appcmd add apppool /apppool.name:prueba2.Financiero /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Financiero.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/GestionTrabajo.Api" /physicalPath:"C:\inetpub\prueba2\GestionTrabajo.Api" /applicationPool:"prueba2.GestionTrabajo" &&appcmd add apppool /apppool.name:prueba2.GestionTrabajo  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/GestionTrabajo.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/Interfaces.Api" /physicalPath:"C:\inetpub\prueba2\Interfaces.Api" /applicationPool:"prueba2.Interfaces" && appcmd add apppool /apppool.name:prueba2.Interfaces /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Interfaces.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 



appcmd add app /site.name:"prueba2" /path:"/Logistica.Api" /physicalPath:"C:\inetpub\prueba2\Logistica.Api" /applicationPool:"prueba2.Logistica" && appcmd add apppool /apppool.name:prueba2.Logistica  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Logistica.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/MantenimientoMaquinaria.Api" /physicalPath:"C:\inetpub\prueba2\MantenimientoMaquinaria.Api" /applicationPool:"prueba2.MantenimientoMaquinaria" && appcmd add apppool /apppool.name:prueba2.MantenimientoMaquinaria  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/MantenimientoMaquinaria.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/Salud.Api" /physicalPath:"C:\inetpub\prueba2\Salud.Api" /applicationPool:"prueba2.Salud" && appcmd add apppool /apppool.name:prueba2.Salud /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Salud.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/Security.Api" /physicalPath:"C:\inetpub\prueba2\Security.Api" /applicationPool:"prueba2.Security" && appcmd add apppool /apppool.name:prueba2.Security /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Security.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/TablasSistema.Api" /physicalPath:"C:\inetpub\prueba2\TablasSistema.Api" /applicationPool:"prueba2.TablasSistema" && appcmd add apppool /apppool.name:prueba2.TablasSistema /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/TablasSistema.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"prueba2" /path:"/Ventas.Api" /physicalPath:"C:\inetpub\prueba2\Ventas.Api" /applicationPool:"prueba2.Ventas" && appcmd add apppool /apppool.name:prueba2.Ventas /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:prueba2/Ventas.Api /path:/recursos /physicalPath:E:\Apps\prueba2 /username:small /password:123456Aa >> salida.txt 




