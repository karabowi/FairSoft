# Copyright 2013-2020 Lawrence Livermore National Security, LLC and other
#   Spack Project Developers. See the top-level COPYRIGHT file for details.
# Copyright 2020 GSI Helmholtz Centre for Heavy Ion Research GmbH,
#   Darmstadt, Germany
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack import *


class Pandaroot(CMakePackage):
    git = 'https://git.panda.gsi.de/PandaRootGroup/PandaRoot'
    homepage = 'https://git.panda.gsi.de/PandaRootGroup/PandaRoot'

    version('develop', branch='dev')

    depends_on('fairroot')

    depends_on('fairlogger')
    depends_on('geant3')
    depends_on('geant4~threads')
    depends_on('geant4_vmc')
    depends_on('pythia6')
    depends_on('pythia8')

    def cmake_args(self):
        args = ['-DCMAKE_CXX_STANDARD=11']
        return args

    def setup_build_environment(self, env):
        env.set("FAIRROOTPATH", self.spec['fairroot'].prefix)
        env.set("SIMPATH", self.spec["fairroot"].prefix)
        env.append_path('CPATH', self.spec['fairlogger'].prefix.include)
