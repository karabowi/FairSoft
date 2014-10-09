#!/bin/bash

   echo $arch

   if [ "$debug" = "yes" ];
   then
     if [ "$compiler" = "Clang" -a "$arch" = "linux" ]; then
       debugstring=""
     else
       debugstring="-DCMAKE_BUILD_TYPE=Debug"
     fi
   else
     debugstring=""
   fi   
   ########### Xrootd has problems with gcc4.3.0 and 4.3.1 
   gcc_major_version=$(gcc -dumpversion | cut -c 1)
   gcc_minor_version=$(gcc -dumpversion | cut -c 3)
   if [ $gcc_major_version -ge 4 -a $gcc_minor_version -ge 3 ];
   then
      XROOTD="-Dxrootd=OFF"
   else
      XROOTD=" "
    fi
   #######################################################

   OPENGL=" "
   if [ "$compiler" = "Clang" ]; then
     root_comp_flag="-DCMAKE_C_COMPILER=Clang -DCMAKE_CXXCOMPILER=Clang"
     if [ $haslibcxx ]; then
       root_comp_flag="-DCMAKE_C_COMPILER=Clang -DCMAKE_CXXCOMPILER=Clang -Dcxx11=ON -Dlibcxx=ON"
     fi
     if [ "$platform" = "linux" ]; then
       OPENGL="-DOPENGL_INCLUDE_DIR=$SIMPATH_INSTALL/include -DOPENGL_gl_LIBRARY=$SIMPATH_INSTALL/lib"
     fi
   else
     root_comp_flag="-DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX -DCMAKE_LINKER=$CXX"   
   fi

   ########### Roofit has problems with gcc3.3.5  
   gcc_major_version=$(gcc -dumpversion | cut -c 1)
   gcc_minor_version=$(gcc -dumpversion | cut -c 3)
   gcc_sub_version=$(gcc -dumpversion | cut -c 5)
   
   if [ $gcc_major_version -eq 3 -a $gcc_minor_version -eq 3 -a $gcc_sub_version -eq 5 ];
   then
      ROOFIT=" "
   else
      ROOFIT="-Droofit=ON"
    fi

   if [ "$build_python" = "yes" ];
   then
      PYTHONBUILD="-Dpython=ON"
   else   
      PYTHONBUILD=" "
   fi
   
   #######################################################
      
     pythia6_libdir=$SIMPATH_INSTALL/lib
     pythia8_libdir=$SIMPATH_INSTALL/lib
     pythia8_incdir=$SIMPATH_INSTALL/include
     gsl_dir=$SIMPATH_INSTALL
     etc_string="-DCMAKE_INSTALL_SYSCONFDIR=$SIMPATH_INSTALL/share/root/etc"
     prefix_string="-DCMAKE_INSTALL_PREFIX=$install_prefix"
 
     cmake ../ -Dsoversion=ON $PYTHONBUILD $XROOTD  $ROOFIT \
                    -Dminuit2=ON  -Dgdml=ON -Dxml=ON \
		    -Dbuiltin-ftgl=ON -Dbuiltin-glew=ON \
                    -Dbuiltin-freetype=ON $OPENGL \
		    -DPYTHIA6_LIBRARY=$pythia6_libdir \
		    -DPYTHIA8_LIBRARY=$pythia8_libdir \
		    -DPYTHIA8_INCLUDE_DIR=$pythia8_incdir \
		    -Dmysql=ON -Dpgsql=ON \
                    -Dglobus=OFF \
                    -Dreflex=OFF \
                    -Dcintex=OFF \
                    -Dvc=ON -Dhttp=ON \
                    -DGSL_DIR=$gsl_dir \
                    -DCMAKE_F_COMPILER=$FC $root_comp_flag $prefix_string \
                    $etc_string -Dgnuinstall=ON $debugstring

