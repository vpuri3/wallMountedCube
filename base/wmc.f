c-----------------------------------------------------------------------
c  nek5000 user-file template
c
c  user specified routines:
c     - uservp  : variable properties
c     - userf   : local acceleration term for fluid
c     - userq   : local source term for scalars
c     - userbc  : boundary conditions
c     - useric  : initial conditions
c     - userchk : general purpose routine for checking errors etc.
c     - userqtl : thermal divergence for lowMach number flows 
c     - usrdat  : modify element vertices 
c     - usrdat2 : modify mesh coordinates
c     - usrdat3 : general purpose routine for initialization
c     
c-----------------------------------------------------------------------
c     include 'file.usr'
c-----------------------------------------------------------------------
      subroutine uservp(ix,iy,iz,eg) ! set variable properties
c     implicit none
      integer ix,iy,iz,eg
     
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e
c     e = gllel(eg)

      udiff  = 0.0
      utrans = 0.0

c     udiff  = cpfld(ifield,1)
c     utrans = cpfld(ifield,2)

      return
      end
c-----------------------------------------------------------------------
      subroutine userf(ix,iy,iz,eg) ! set acceleration term
c
c     Note: this is an acceleration term, NOT a force!
c     Thus, ffx will subsequently be multiplied by rho(x,t).
c
c      implicit none

      integer ix,iy,iz,eg

      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e
c     e = gllel(eg)

      ffx = 0.0
      ffy = 0.0
      ffz = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userq(ix,iy,iz,eg) ! set source term

c      implicit none

      integer ix,iy,iz,eg

      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e
c     e = gllel(eg)

      qvol = 0.0
c     avol = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userbc(ix,iy,iz,iside,eg) ! set up boundary conditions
c
c     NOTE ::: This subroutine MAY NOT be called by every process
c
c      implicit none

      integer ix,iy,iz,iside,eg

      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

c     if (cbc(iside,gllel(eg),ifield).eq.'v01')
c	Empty/no call to with BCs P, W, SYM!

      ux   = 0.0
      uy   = 0.0
      uz   = 0.0
      temp = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine useric(ix,iy,iz,eg) ! set up initial conditions

c      implicit none

      integer ix,iy,iz,eg

      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      ux   = 0.0
      uy   = 0.0
      uz   = 0.0
      temp = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userchk()
c     implicit none
      include 'SIZE'
      include 'TOTAL'

      integer f,ifld
      character*3 bctyp

      integer e,k,ntot
      integer idimt,iface,j1,js1,jf1,jskip1,j2,js2,jf2,jskip2
      real faceid

      ntot = lx1*ly1*lz1*nelv
c
      call rzero(vx,ntot)
      call rzero(vy,ntot)
      call rzero(vz,ntot)
c
c outpost normals
c
      call dsset(nx1,ny1,nz1)

      do e=1,nelv
      do f=1,2*ndim
        iface  = eface1(f)   ! surface to volume shifts
        js1    = skpdat(1,iface)
        jf1    = skpdat(2,iface)
        jskip1 = skpdat(3,iface)
        js2    = skpdat(4,iface)
        jf2    = skpdat(5,iface)
        jskip2 = skpdat(6,iface)

        if    (cbc(f,e,1).eq.'v  ')then
          faceid=1
        elseif(cbc(f,e,1).eq.'O  ')then
          faceid=2
        elseif(cbc(f,e,1).eq.'W  ')then
          faceid=3
        elseif(cbc(f,e,1).eq.'SYM')then
          faceid=4
        elseif(cbc(f,e,1).eq.'p  ')then
          faceid=5
        else 
          faceid=0
        endif

        k = 0
        do j2=js2,jf2,jskip2
        do j1=js1,jf1,jskip1
          k = k + 1
 
          vx(j1,j2,1,e) = unx(k,1,f,e)      ! face normal X-comp
          vy(j1,j2,1,e) = uny(k,1,f,e)      !             Y
          vz(j1,j2,1,e) = unz(k,1,f,e)      !             Z
          pr(j1,j2,1,e) = faceid
 
        enddo
        enddo

      enddo
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine userqtl ! Set thermal divergence

      call userqtl_scig 

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat()   ! This routine to modify element vertices

c      implicit none

      include 'SIZE'
      include 'TOTAL'

      common /cdsmag/ ediff(lx1,ly1,lz1,lelv)

      n = nx1*ny1*nz1*nelt 
      call cfill(ediff,param(2),n)  ! initialize viscosity

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat2()  ! This routine to modify mesh coordinates
c     implicit none
      include 'SIZE'
      include 'TOTAL'

      integer i,n, iel, ifc, id_face
      real xmin,xmax,ymin,ymax,scaley,scalex
      real glmin,glmax

      n=nx1*ny1*nz1*nelv

      param(93) = 20.0
      param(94) = 3.0
      param(95) = 5.0
      param(99) = 4.0

      filterType = 1
      param(101) = 1.0
      param(103) = 0.0001
c     param(101) = 2.0
c     param(103) = 0.2

c
c from gmsh2nek
c
c	   total quad element number is         2736
c	   total hex element number is         8424
c	   ******************************************************
c	   Boundary info summary
c	   BoundaryName     BoundaryID
c	   inlet           1
c	   outlet           2
c	   wall           3
c	   sym           4
c	   pm           5
c	   pp           6
c	   ******************************************************

      do iel=1,nelv
        do ifc=1,2*ndim

          id_face = bc(5,ifc,iel,1)

          if     (id_face.eq.1) then           ! inlet
             cbc(ifc,iel,1) = 'v  '
          elseif (id_face.eq.2) then           ! outlet
             cbc(ifc,iel,1) = 'O  '
          elseif (id_face.eq.3) then           ! wall
             cbc(ifc,iel,1) = 'W  '
          elseif (id_face.eq.4) then           ! symmetry
             cbc(ifc,iel,1) = 'SYM'
          elseif (id_face.eq.5) then           ! pm - do nothing
c             !cbc(ifc,iel,1) = 'p  '          
          elseif (id_face.eq.6) then           ! pp - do nothing
c             !cbc(ifc,iel,1) = 'p  '          
c         elseif (id_face.eq.7) then           ! interpolate (for neknek)
c            cbc(ifc,iel,1) = 'int'
          endif

        enddo
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat3()

c      implicit none

      include 'SIZE'
      include 'TOTAL'

      return
      end
c-----------------------------------------------------------------------
      subroutine e2_out
      include 'SIZE'
      include 'TOTAL'
c
c     prints out uvwp abs max and volume average/rms
 

      n   = nx1*ny1*nz1*nelv
      m   = nx2*ny2*nz2*nelv
      vxm = glamax(vx,n)			! absolute value max
      vym = glamax(vy,n)
      prm = glamax(pr,m)
      vxa = glsc2(vx,   bm1,n) / volvm1		! volume-average
      vya = glsc2(vy,   bm1,n) / volvm1
      pra = glsc2(pr,   bm2,m) / volvm2
      vx2 = glsc3(vx,vx,bm1,n) / volvm1
      vy2 = glsc3(vy,vy,bm1,n) / volvm1
      pr2 = glsc3(pr,pr,bm2,m) / volvm2
      vx2 = vx2 - vxa*vxa
      vy2 = vy2 - vya*vya
      pr2 = pr2 - pra*pra
      if (vx2.gt.0) vx2 = sqrt(vx2)		! volume-rms
      if (vy2.gt.0) vy2 = sqrt(vy2)
      if (pr2.gt.0) pr2 = sqrt(pr2)

      if (if3d) then				! 3D
         vzm = glamax(vz,n)
         vza = glsc2(vz,   bm1,n) / volvm1
         vz2 = glsc3(vz,vz,bm1,n) / volvm1
         vz2 = vz2 - vza*vza
         if (vz2.gt.0) vz2 = sqrt(vz2)

         if (nid.eq.0) write(6,1) istep,time,vxa,vya,vza,pra ! 1-2  3-6
     $                      ,vx2,vy2,vz2,pr2,vxm,vym,vzm,prm ! 7-10 11-13
      else
         if (nid.eq.0) write(6,2) istep,time,vxa,vya,pra     ! 1-2 3-5
     $                          ,vx2,vy2,pr2,vxm,vym,prm     ! 6-8 9-11
      endif
    1 format(i7,1p13e16.7,' e2')
    2 format(i7,1p10e16.7,' e2')

      return
      end
c-----------------------------------------------------------------------

c automatically added by makenek
      subroutine usrdat0() 

      return
      end

c automatically added by makenek
      subroutine usrsetvert(glo_num,nel,nx,ny,nz) ! to modify glo_num
      integer*8 glo_num(1)

      return
      end
