<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html>
    <head>
        <meta name="viewport" content="width=device-width, user-scalable=no">
        <style type="text/css">
            ${css}
        </style>
    </head>
    <%
        BULTO = {'box': 'Cajas',
            'pallete': 'Palletes',
            'cont20': 'Contenedor 20"',
            'cont40','Contenedor 40"'
        }
    %>
    <body>
    	${helper.embed_image('jpeg',str(company.partner_id.image),180, auto)}
        <table class="header" style="border-bottom: 0px solid black; align:right; float:right">
            <tr>
                <td><b>${company.partner_id.name |entity}</b></td>
            </tr>
            <tr>
                <td >${company.partner_id.street or ''|entity}</td>
            </tr>
            <tr>
                <td>Telefono: ${company.partner_id.phone or ''|entity} </td>
            </tr>
            <tr>
                <td>Email: ${company.partner_id.email or ''|entity}<br/></td>
            </tr>
        </table>
        <%
            way = dict([('air','Aereo'), ('sea','Maritimo'), ('land', 'Terrestre')])
            type = dict([('import','Importacion'), ('export','Exportacion'), ('domestic', 'Domestico'), ('transit', 'Transito')])
        %>
        %for o in objects:
            <% setLang(o.partner_id.lang) %>
            <br/>
            <br/>
            <br/>
            <h2 align="center">
                ${_("Referencia")}: ${o.name or ''}
            </h2>
            <h3>
                ${_("Referencia de Cliente")}: ${o.partner_ref or ''}
            </h3>
            <br/>
   	    <div class="act_as_table list_table" style="width:98%;">
                <div class="act_as_cell" style="width:50%;">
                    <div class="act_as_table data_table">
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Zona Origen")}:</div>
                            <div class="act_as_cell">${o.o.freight_gateway_id.name_get()[0][1 or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Remitente")}:</div>
                            <div class="act_as_cell">${o.sender_id.name or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Domicilio")}:</div>
                            <div class="act_as_cell">${o.sender_id.contact_address or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" width="40%">${_("Km Origen")}:</div>
                            <div class="act_as_cell">${o.start_km or ''}</div>
                        </div>
                    </div>
                </div>
                <div class="act_as_cell" style="width:50%;">
                    <div class="act_as_table data_table">
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Zona Destino")}:</div>
                            <div class="act_as_cell">${freight_destination_id.name_get()[0][1] or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Destinatario")}:</div>
                            <div class="act_as_cell" align="right">${o.addresse_id.name}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" width="40%">${_("Domicilio")}:</div>
                            <div class="act_as_cell">${o.addresse_id.contact_address or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Peso Total")}:</div>
                            <div class="act_as_cell">${o.end_km}</div>
                        </div>
                    </div>
                </div>
            </div>
            <br/>
            <br/>
            <h3>Contenidos</h3>
            <div class="act_as_table list_table">
                    <div class="act_as_row labels">
                        <div class="act_as_cell act_as_colgroup" width="10%">${_("No Bultos")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Tipo Bultos")}</div>
                        <div class="act_as_cell act_as_colgroup" width="20%">${_("Contenido")}</div>
                        <div class="act_as_cell act_as_colgroup" width="10%">${_("Peso Kg")}</div>
                        <div class="act_as_cell act_as_colgroup" width="10%">${_("Volumen M3")}</div>
                        <div class="act_as_cell act_as_colgroup" width="10%">${_("Peso Cargable")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Valor")}</div>
                        <div class="act_as_cell act_as_colgroup" width="10%">${_("Asegurado")}</div>
                    </div>
                % for line in o.content_ids:
                    <div class="act_as_row lines">
                        <div class="act_as_cell" style="width:10%; text-align:center;">${line.packages}</div>
                        <div class="act_as_cell" width="15%">${BULTO[line.package_type]}</div>
                        <div class="act_as_cell" width="20%">${line.name}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${str(line.gross_weight * float(line.weight_type))}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${str(line.volume * float(line.volume_type))}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${line.chargable_weight or ''}</div>
                        <div class="act_as_call" style="width:15%; text-align:center;">${line.amount or ''}</div>
                        <div class="act_as_call" style="width:10%; text-align:center;">${'Si' if line.insured else 'No'}</div>
                    </div>
                % endfor
            </div>
            <br/>
            <br/>
            <p>Para mas información de su embarque, visite las siguentes ligas</p>
            <div class="act_as_table">
                <div class="act_as_row" >
                    <div class="act_as_cell" width="10%">${_("Documentos")}:</div>
                    <div class="act_as_cell"><a href="${o.docs_link or ''}">${o.docs_link or ''}</a></div>
                </div>
            </div>
        % endfor
    </div>
    </body>
</html>
