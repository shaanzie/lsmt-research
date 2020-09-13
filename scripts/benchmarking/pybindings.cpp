#include "workloadGenerator.cpp"
#include <boost/python.hpp>


 BOOST_PYTHON_MODULE(Workload)  // Name here must match the name of the final shared library, i.e. mantid.dll or mantid.so
 {
    boost::python::class_<QueryGenerator>("QueryGenerator")
        .def(boost::python::init<double, double, double>())
        .def("get_query_type", (std::string(QueryGenerator::*)())&QueryGenerator::next_query_py)
      ;
 }
