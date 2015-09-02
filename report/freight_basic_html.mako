<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html>
    <head>
        <meta name="viewport" content="width=device-width, user-scalable=no">
        <style type="text/css">
            ${css}
        </style>
        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <%!
            from time import strftime
            from time import strptime as stime
            import datetime

            def get_gantt_data (task_ids):
                res = []
                day = 0
                for i in range(len(task_ids)):
                    res.append([])
                    res[i].append(task_ids[i].state)
                    res[i].append(task_ids[i].name)
                    res[i].append(task_ids[i].graph_init_date)
                    res[i].append(task_ids[i].graph_end_date)
                return res
        %>
    </head>
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
            <script type="text/javascript">
                google.load("visualization", "1", {packages: ["timeline"]});
                google.setOnLoadCallback(drawChart);

                function drawChart() {
                    var container = document.getElementById('timeline');
                    var chart = new google.visualization.Timeline(container);
                    var dataTable = new google.visualization.DataTable();

                    dataTable.addColumn({ type: 'string', id: 'State' });
                    dataTable.addColumn({ type: 'string', id: 'Name' });
                    dataTable.addColumn({ type: 'date', id: 'Start' });
                    dataTable.addColumn({ type: 'date', id: 'End' });
                    <% data = get_gantt_data(o.task_ids) %>
                    dataTable.addRows([
                    %for i in range(len(data)):
                    ['${data[i][0]}', '${data[i][1]}', new Date('${data[i][2]}'), new Date('${data[i][3]}')]${(i!=len(data)-1) and ',' or ''}
                    %endfor
                    ]);

                    var options = { 
                        timeline: { colorByRowLabel: true,
                                    showRowLabels: false,
                                    groupByRowLabel:false
                                },
                        height:450,
                        width:750
                    };

                    chart.draw(dataTable, options);
                }
            </script>
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
                            <div class="act_as_cell labels" style="width:40%;">${_("Cliente")}:</div>
                            <div class="act_as_cell">${o.partner_id.name or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Medio Principal de Trasporte")}:</div>
                            <div class="act_as_cell">${way[o.shipment_way] or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Tipo de Operación")}:</div>
                            <div class="act_as_cell">${type[o.shipment_type] or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" style="width:40%;">${_("Origen")}:</div>
                            <div class="act_as_cell">${o.gateway_id.name_get()[0][1] or ''}</div>
                        </div>
                        <div class="act_as_row">
                            <div class="act_as_cell labels" width="40%">${_("Destino")}:</div>
                            <div class="act_as_cell">${o.destination_id.name_get()[0][1] or ''}</div>
                        </div>
                    </div>
                </div>
                <div class="act_as_cell" style="width:50%;">
                    <div class="act_as_table data_table">
                        <div class="act_as_row">
                        %if o.state != 'draft':
                            <div class="act_as_cell labels" style="width:40%;">${_("Fecha de Inicio")}:</div>
                            <div class="act_as_cell">${formatLang(o.initial_date, date=True)}</div>
                        %else:
                            <div class="act_as_cell labels" style="width:40%;">${_("Fecha Estimada de Incio")}:</div>
                            <div class="act_as_cell">${formatLang(o.etd_date, date=True)}</div>
                        %endif
                        </div>
                        <div class="act_as_row">
                        %if o.state == 'done':
                            <div class="act_as_cell labels" style="width:40%;">${_("Fecha de Finalización")}:</div>
                            <div class="act_as_cell" align="right">${formatLang(o.final_date, date=True)}</div>
                        %else:
                            <div class="act_as_cell labels" style="width:40%;">${_("Fecha Estimada de Finalización")}:</div>
                            <div class="act_as_cell" align="right">${formatLang(o.eta_date, date=True)}</div>
                        %endif
                        </div>
                        <div class="act_as_row">
                        %if o.total_volume:
                            <div class="act_as_cell labels" width="40%">${_("Volumen Total")}:</div>
                            <div class="act_as_cell">${o.total_volume}</div>
                        %endif
                        </div>
                        <div class="act_as_row">
                        %if o.total_weight:
                            <div class="act_as_cell labels" style="width:40%;">${_("Peso Total")}:</div>
                            <div class="act_as_cell">${o.total_weight}</div>
                        %endif
                        </div>
                        <div class="act_as_row">
                        %if o.total_chargable_weight:
                            <div class="act_as_cell labels" style="width:40%;">${_("Peso Cargable")}:</div>
                            <div class="act_as_cell">${o.total_chargable_weight}</div>
                        %endif
                        </div>
                        <div class="act_as_row">
                        %if o.amount_total:
                            <div class="act_as_cell labels" style="width:40%;">${_("Valor de la Mercancia")}:</div>
                            <div class="act_as_cell">${formatLang(o.amount_total, monetary=True)}</div>
                        %endif
                        </div>
                    </div>
                </div>
            </div>            
            <br/>
            <br/>
            <div align="center" id="timeline" style="width:750px;heigth:450px;"></div>
            <div class="act_as_table list_table">
                    <div class="act_as_row labels">
                        <div class="act_as_cell act_as_colgroup" width="40%">${_("Actividad")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Fecha Estimada de Inicio")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Fecha de Inicio")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Fecha Estimada de Finalización")}</div>
                        <div class="act_as_cell act_as_colgroup" width="15%">${_("Fecha de Finalización")}</div>
                    </div>
                % for task in o.task_ids:
                    % if task.state != 'canceled':
                        <div class="act_as_row lines">
                            <div class="act_as_cell" width="40%">${task.name}</div>
                            <div class="act_as_cell" style="width:15%; text-align:center;">${formatLang(task.date_est_start,date=True) or ''}</div>
                            <div class="act_as_cell" style="width:15%; text-align:center;">${formatLang(task.date_start, date=True) or ''}</div>
                            <div class="act_as_cell" style="width:15%; text-align:center;">${formatLang(task.date_estimated,date=True) or ''}</div>
                            <div class="act_as_cell" style="width:15%; text-align:center;">${formatLang(task.date_end, date=True) or ''}</div>
                        </div>
                    % endif
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
