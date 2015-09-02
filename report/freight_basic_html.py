# -*- encoding: utf-8 -*-
###########################################################################
#    Module Written to OpenERP, Open Source Management Solution
#
#    Copyright (c) 2013 Jorge Pintor
#    All Rights Reserved.
############################################################################
#    Author: Geekyworld
#    Coded by: Chidowsky (pintorjorge.52@gmail.com)
############################################################################
#
#    This program is free software: you can redistribute it and/or modify it under the terms of the
#    GNU Affero General Public License as published by the Free Software Foundation, either version
#    3 of the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
#    without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License along with this
#    program.  If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

from openerp.report import report_sxw
from openerp.osv import osv
from openerp import pooler
from report_webkit import webkit_report
from time import strftime, strptime

class freight_basic_html(report_sxw.rml_parse):
    def __init__(self, cr, uid, name, context=None):
        if context is None:
            context = {}
        super(shipment_basic_html, self).__init__(
            cr, uid, name, context=context)
        self.localcontext.update({
        	'company_address': self._company_address,
        	'time': time,
            'cr':cr,
            'uid': uid
        })

webkit_report.WebKitParser('report.freight.basic.info.webkit',
            'shipment.shipment',
            'addons/freight_managment/report/freight_basic_html.mako',
            parser=freight_basic_html)
