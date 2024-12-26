export const tableColumns = [
  {
    name: 'codigo',
    label: 'Código',
    field: 'codigo',
    align: 'left',
    sortable: true
  },
  {
    name: 'instalacion',
    label: 'Instalación',
    field: 'instalacion',
    align: 'left',
    sortable: true
  },
  {
    name: 'nombre',
    label: 'Nombre',
    field: 'nombre',
    align: 'left',
    sortable: true
  },
  {
    name: 'medidor',
    label: 'Medidor',
    field: 'medidor',
    align: 'left',
    sortable: true
  },
  {
    name: 'mes',
    label: 'Mes',
    field: 'mes_nombre',
    align: 'left',
    sortable: true
  },
  {
    name: 'year',
    label: 'Año',
    field: 'year',
    align: 'left',
    sortable: true
  },
  {
    name: 'lectura',
    label: 'Lectura',
    field: 'lectura',
    align: 'right',
    sortable: true
  },
  {
    name: 'consumo',
    label: 'Consumo',
    field: 'consumo',
    align: 'right',
    sortable: true
  },
  {
    name: 'otros_cobros',
    label: 'Otros Cobros',
    field: 'otros_cobros',
    align: 'right',
    sortable: true,
    format: val => val?.toFixed(2) || '0.00'
  },
  {
    name: 'reconexion',
    label: 'Reconexión',
    field: 'reconexion',
    align: 'right',
    sortable: true,
    format: val => val?.toFixed(2) || '0.00'
  },
  {
    name: 'facturado',
    label: 'Facturado',
    field: 'facturado',
    align: 'center',
    sortable: true
  }
];