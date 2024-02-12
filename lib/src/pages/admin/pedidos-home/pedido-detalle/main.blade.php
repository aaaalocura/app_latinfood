<div class="row sales layout-top-spacing">
    <div class="col-sm-12">
        <div class="widget widget-chart-one  widget-table-two">
            <div class="widget-heading">
                <h4 class="card-title">
                    <b>Habitaciones</b>
                </h4>
                <ul class="tabs tab-pills">
                    <li>
                        <a href="javascript:void(0)" class="tabmenu badge outline-badge-dark" data-toggle="modal"
                            data-target="#theModal">Crear Habitacion</a>
                    </li>
                </ul>
            </div>
            <div class="widget-content">
                <div class="row">
                    @foreach($habitaciones as $habitacion)
                    <a href="{{ route('habitaciones.detalle', ['id' => $habitacion->id]) }}"
                        class="text-decoration-none">
                        <div class="col-sm-4 mb-4">
                            <div
                                class="card border-{{ $habitacion->estadoReserva === 'Ocupada' ? 'danger' : 'success' }} component-card_1">
                                <!-- Imagen de la habitación -->
                                <img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDN8fHxlbnwwfHx8fHw%3D"
                                    class="card-img-top component-IMG" alt="Imagen de la habitación">

                                <div class="card-body">
                                    <h5 class="card-title">CABAÑA #{{ $habitacion->NumeroHabitacion }}</h5>
                                    <p class="card-text PARRAFO">
                                        <strong>Nivel de Piso:</strong> {{ $habitacion->Piso }}<br>
                                        <strong>Capacidad:</strong> {{ $habitacion->Capacidad }}<br>
                                        <strong>Precio por Noche:</strong> {{ $habitacion->PrecioPorNoche }}<br>
                                    </p>
                                    <hr>
                                    <!-- Botón dinámico según el estado de la reserva -->
                                    @if($habitacion->estadoReserva === 'Disponible')
                                    <div class="text-center">
                                        <button class="btn btn-success mb-2 mr-2 btn-rounded">Reservar <svg
                                                viewBox="0 0 24 24" width="24" height="24" stroke="currentColor"
                                                stroke-width="2" fill="none" stroke-linecap="round"
                                                stroke-linejoin="round" class="css-i6dzq1">
                                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                                <polyline points="12 5 19 12 12 19"></polyline>
                                            </svg>
                                        </button>
                                    </div>
                                    @elseif($habitacion->estadoReserva === 'Ocupada')
                                    <div class="text-center">
                                        <button data-toggle="modal" data-target="#theModal"
                                            class="btn btn-danger mb-2 mr-2 btn-rounded">Ocupado <svg
                                                viewBox="0 0 24 24" width="24" height="24" stroke="currentColor"
                                                stroke-width="2" fill="none" stroke-linecap="round"
                                                stroke-linejoin="round" class="css-i6dzq1">
                                                <path
                                                    d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z">
                                                </path>
                                                <line x1="12" y1="9" x2="12" y2="13"></line>
                                                <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    @endif

                                </div>
                            </div>
                        </div>
                    </a>
                    <!-- Estado de la reserva en la esquina superior derecha -->
                    <div class="estado-reserva-badge">
                        <span
                            class="badge badge-{{ $habitacion->estadoReserva === 'Ocupada' ? 'danger' : 'success' }} component-SPAN">
                            {{ $habitacion->estadoReserva }}
                        </span>
                    </div>
                </div>


            </div>
            @endforeach
        </div>
    </div>
</div>

@include('livewire.habitaciones.modal.habitacion')
<script>
var tabla = document.querySelector("#tabla3");
var dataTable = new DataTable(tabla, {
    fixedHeight: true,
});
</script>
<style>
.card-title {
    font-size: 20px;
    font-weight: 700;
    letter-spacing: 1px;
    margin-bottom: 15px;
}

.PARRAFO {
    color: #888ea8;
    line-height: 22px;
}

hr {
    margin-top: 1.5rem;
    margin-bottom: 1.5rem;
    border: 1px solid #e0e6ed;
    border-top: 2px solid #e0e6ed;
    /* Cambia el color y grosor según tu preferencia */
}

.component-card_1 {
    border: 3px solid #e0e6ed;
    border-radius: 15px;
    width: auto;
    margin: 0 auto;
    box-shadow: 4px 6px 10px -3px #bfc9d4;
    position: relative;
    overflow: hidden;
    /* Asegura que el estado-reserva-badge no se salga de la tarjeta */
    transition: transform 0.3s ease-in-out;
}

.component-card_1:hover {
    transform: scale(1.05);
    transition: transform 0.3s ease-in-out;
}

.component-card_1:hover .estado-reserva-badge {
    opacity: 1;
    /* Se muestra al pasar el ratón */
}

.component-IMG {
    border-top-left-radius: 15px;
    border-top-right-radius: 15px;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
}

.estado-reserva-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    font-size: 30px;
    transition: opacity 0.3s ease-in-out;
    opacity: 0;
    /* Inicialmente oculto */

}

.component-SPAN {
    border-radius: 15px;

}
</style>