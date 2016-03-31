// -*- Mode:C++ -*-

/**************************************************************************************************/
/*                                                                                                */
/* Copyright (C) 2016 University of Hull                                                          */
/*                                                                                                */
/**************************************************************************************************/
/*                                                                                                */
/*  module     :  dummy/main.cpp                                                                  */
/*  project    :                                                                                  */
/*  description:                                                                                  */
/*                                                                                                */
/**************************************************************************************************/

// includes, system

#include <cstdlib> // EXIT_SUCCESS
#include <memory>  // std::unique_ptr<>

// includes, project

#include <hugh/dummy/dummy.hpp>

// internal unnamed namespace

namespace {
  
  // types, internal (class, enum, struct, union, typedef)

  // variables, internal
  
  // functions, internal

} // namespace {

int
main(int /* argc */, char* /* argv */[])
{
  int result(EXIT_SUCCESS);

  try {
    namespace hd = hugh::dummy;
    
    std::unique_ptr<hd::dummy_class> const dc(new hd::dummy_class);
  }

  catch (...) {
    result = EXIT_FAILURE;
  }
  
  return result;
}
