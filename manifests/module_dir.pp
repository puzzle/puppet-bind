class bind::module_dir {
    include common::moduledir
    module_dir { [ 'bind', 'bind/zones', 'bind/options.d' ]: }
}
