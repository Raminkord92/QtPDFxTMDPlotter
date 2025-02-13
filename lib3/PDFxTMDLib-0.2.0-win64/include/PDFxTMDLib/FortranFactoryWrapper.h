// FactoryWrapper.h
#pragma once
#include "Factory.h"

extern "C"
{
    // Wrapper for CouplingFactory
    void *create_coupling_factory();
    void delete_coupling_factory(void *factory);
    void *mk_coupling(void *factory, const char *pdfSetName);

    // Wrapper for GenericTMDFactory
    void *create_tmd_factory();
    void delete_tmd_factory(void *factory);
    void *mk_tmd(void *factory, const char *pdfSetName, int setMember);

    // Wrapper for GenericCPDFFactory
    void *create_cpdf_factory();
    void delete_cpdf_factory(void *factory);
    void *mk_cpdf(void *factory, const char *pdfSetName, int setMember);
}