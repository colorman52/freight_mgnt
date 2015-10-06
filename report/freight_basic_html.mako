<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html>
    <head>
        <meta name="viewport" content="width=device-width, user-scalable=no">
        <style type="text/css">
            ${css}
        </style>
    </head>
    <%
        BULTO = {'box':'Cajas', 'pallete':'Palletes', 'cont20':'Contenedor 20"', 'cont40':'Contenedor 40"'}
    %>
    <body>
    	${helper.embed_image('jpeg',str(company.partner_id.image),180, auto)}
        <table class="header" style="border-bottom: 0px solid black; align:right; float:right">
            <tr>
                <td><b>${company.partner_id.name |entity}</b></td>
            </tr>
            <tr>
                <td >${company.partner_id.street or ''|entity} ${companycompany.partner_id.street2 or ''|entity</td>
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
                ${_("Cata Porte")}: ${o.name or ''}
            </h2>
            <h3>
                ${_("Referencia de Cliente")}: ${o.partner_ref or ''}
            </h3>
<<<<<<< HEAD
            <div class="act_as_table list_table">
=======
            <br/>
   	    <div class="act_as_table list_table">
>>>>>>> ded6136e556568b8f34d31b59b88c4b9bf69557e
                <div class="act_as_cell" style="width:50%;">
                    <div class="act_as_table data_table">
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Zona Origen")}:</div>
                            <div class="act_as_cell">${o.freight_gateway_id.name or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Remitente")}:</div>
                            <div class="act_as_cell">${o.sender_id.name or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Teléfono")}:</div>
                            <div class="act_as_cell">${o.sender_id.phone or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;height:40px;">${_("Domicilio")}:</div>
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
                            <div class="act_as_cell">${o.freight_destination_id.name or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Destinatario")}:</div>
                            <div class="act_as_cell" align="right">${o.addresse_id.name}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Teléfono")}:</div>
                            <div class="act_as_cell">${o.addresse_id.phone or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" width="40%" height="40px">${_("Domicilio")}:</div>
                            <div class="act_as_cell">${o.addresse_id.contact_address or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Km Destino")}:</div>
                            <div class="act_as_cell">${o.end_km}</div>
                        </div>
                    </div>
                </div>
            </div>
            <h3>Contenidos</h3>
            <div class="act_as_table data_table">
                <div class="act_as_thead">
                    <div class="act_as_row labels">
                        <div class="act_as_cell act_as_colgroup labels" width="7%">${_("No Bultos")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="15%">${_("Tipo Bultos")}</div>
                        <div class="act_as_cell act_as_colgroup labels">${_("Contenido")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="10%">${_("Peso Kg")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="10%">${_("Volumen M3")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="10%">${_("Peso Cargable")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="15%">${_("Valor")}</div>
                        <div class="act_as_cell act_as_colgroup labels" width="7%">${_("Asegurado")}</div>
                    </div>
                </div>
                <div class="act_as_tbody">
                % for line in o.content_ids:
                    <div class="act_as_row lines">
                        <div class="act_as_cell" style="width:7%; text-align:center;">${line.packages or ''}</div>
                        <div class="act_as_cell" width="15%">${BULTO[line.package_type] or ''}</div>
                        <div class="act_as_cell">${line.name or ''}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${str(line.gross_weight * float(line.weight_type)) or ''}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${str(line.volume * float(line.volume_type)) or ''}</div>
                        <div class="act_as_cell" style="width:10%; text-align:center;">${line.chargable_weight or ''}</div>
                        <div class="act_as_cell" style="width:15%; text-align:center;">${line.amount or ''}</div>
                        <div class="act_as_cell" style="width:7%; text-align:center;">${'Si' if line.insured else 'No'}</div>
                    </div>
                % endfor
                </div>
                <div class="act_as_tfoot">
                    <div class="act_as_cell" style="width:7%; text-align:center;"></div>
                    <div class="act_as_cell" width="15%"></div>
                    <div class="act_as_cell"></div>
                    <div class="act_as_cell" style="width:10%; text-align:center;">${o.total_weight or ''}</div>
                    <div class="act_as_cell" style="width:10%; text-align:center;">${o.total_volume or ''}</div>
                    <div class="act_as_cell" style="width:10%; text-align:center;">${o.total_chargable_weight or ''}</div>
<<<<<<< HEAD
                    <div class="act_as_cell" style="width:15%; text-align:center;">${_("MXN $")} ${o.amount_total or ''}</div>
=======
                    <div class="act_as_cell" style="width:15%; text-align:center;">${_("MXN $") + (o.amount_total or '')}</div>
>>>>>>> ded6136e556568b8f34d31b59b88c4b9bf69557e
                    <div class="act_as_cell" style="width:7%; text-align:center;"></div>
                </div>
            </div>
            <p>Para mas información de su embarque, visite las siguentes ligas</p>
            <div class="act_as_table">
                <div class="act_as_row">
                    <div class="act_as_cell" width="10%">${_("Documentos")}:</div>
                    <div class="act_as_cell"><a href="${o.docs_link or ''}">${o.docs_link or ''}</a></div>
                </div>
            </div>
            <br/>
            <div class="act_as_table list_table">
                <div class="act_as_row">
                    <div class="act_as_cell" style="width:40%;text-align:center;border-bottom:2pt"><b>Acepto Términos y Condiciones</b><br/></div>
                    <div class="act_as_cell" style="width:20%;"><br/></div>
                    <div class="act_as_cell" style="width:40%;text-align:center;border-bottom:2pt"><b>Recibo de Conformidad de Mercancías</b><br/></div>
                </div>
                <div class="act_as_row">
                    <div class="act_as_cell" style="width:40%;text-align:center;border-bottom:2pt">Firma<br/></div>
                    <div class="act_as_cell" style="width:20%;"><br/></div>
                    <div class="act_as_cell" style="width:40%;text-align:center;border-bottom:2pt">Firma<br/></div>
                </div>
                <div class="act_as_row">
                    <div class="act_as_cell" style="width:40%;text-align:center;border-bottom:2pt">Nombre<br/></div>
                    <div class="act_as_cell" style="width:20%;"><br/></div>
                    <div class="act_as_cell" style="width:40%;text-align:center;">Nombre<br/></div>
                </div>
                <div class="act_as_row">
                    <div class="act_as_cell" style="width:40%;text-align:center;">Fecha</div>
                    <div class="act_as_cell" style="width:20%;"></div>
                    <div class="act_as_cell" style="width:40%;"></div>
                </div>
            </div>
        % endfor
    </div>
    </body>
</html>
