# -*- encoding: utf-8 -*-
####################################################################################################
#    Module Written to OpenERP, Open Source Management Solution
#
#    Copyright (c) 2013 Jorge Pintor
#    All Rights Reserved.
####################################################################################################
#    Author: DLK Business
#    Coded by: BrandoIsNotASword (triimex-3@hotmail.com)
#              Chidowsky (pintorjorge.52@gmail.com)
####################################################################################################
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
####################################################################################################

from openerp.osv import osv, fields
from datetime import datetime
from openerp.tools.translate import _

class freight_zone(osv.osv):

    _name = 'freight.zone'

    _inherit = 'shipment.city'

    _description = 'Zonas de Envio'

    _columns = {
        'city_id' : fields.many2one ('shipment.city', 'Ciudad',
            required = True),
        'country_id' : fields.related('city_id','country_id',
            type='many2one',
            relation='shipment.city',
            string='País',
            store=False)
    }

class freight_content(osv.osv):
    """
    Declaracion del modelo del shipment_content el cual es el contenido del Embarque, para esta
    primera version no tendra conexion con almacen o con paquetes, esto para agilizar su
    desarrollo y simplificar su funcionamiento
    """

    _inherit = 'shipment.content'

    _description = "Contenido del Embarque"

    _columns = {
        'insured' : fields.boolean('Asegurado')
    }


freight_content()

class freight(osv.osv):
    """
    Clase principal del modulo, esta clase representa en si el embarque representando
    caracteristcias basicas del mismo.
    """

    _inherit = 'shipment.shipment'

    _description = "Embarques"

    def _calculate_km(self, cr, uid, ids, field_name, arg, context):
        res = {}
        for record in self.browse(cr, uid, ids, context=context):
            res[record.id] = record.end_km - record.start_km
        return res

    def _get_code_flr(self, cr, uid, context, *args):
        obj_sequence = self.pool.get('ir.sequence')    
        return obj_sequence.next_by_code(cr, uid, 'freight.sequence', context=context)

    def create(self, cursor, user, vals, context=None):
        if vals.get("shipment_type") == 'domestic':
            vals['name'] = self._get_code_flr(cursor, user, context=context)
        else:
            if vals.get("consolidated") and (not vals.get("parent_id", True) or vals.get("child_ids", False)):
                vals['name'] = self._get_code_master(cursor, user, context=context)
            elif vals['forwarder']:
                vals['name'] = self._get_code_forwarder(cursor, user, context=context)
            else:
                vals['name'] = self._get_code_dlk(cursor, user, context=context)
        return super(shipment, self).create(cursor, user, vals, context=context)

    _columns = {
        'freight_gateway_id': fields.many2one('freight.zone', 'Origen',
            required=False,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'freight_destination_id': fields.many2one('freight.zone', 'Destino',
            required=False,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'sender_id' : fields.many2one('res.partner', 'Remitente',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
        'addresse_id' : fields.many2one('res.partner', 'Destinatario',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
        'start_km' : fields.float('Km Origen',
            digits=(14,2)),
        'end_km' : fields.float('Km Destino',
            digits=(14,2)),
        'total_km' :  fields.function(_calculate_km,
            string='Km Total',
            store=False,
            type='float',
            method=True,
            readonly=True, 
            help="Egresos brutos por el embarque en moneda de la empresa"),
        'customs' : field.char('Aduana',
            size=64,
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'customs_declaration' : fields.many2one('account.invoice', 'Pedimento',
            readonly=True,
            states={'draft':[('readonly',False)]}),
        'operator' : fields.many2one('base.partner', 'Operador',
            readonly = True,
            states={'draft':[('readonly',False)]},
            groups='shipment_tracking.group_shipment_user, portal.group_portal'),
    }

freight()