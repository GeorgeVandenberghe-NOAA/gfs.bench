      subroutine gefs_dozeuv(dod,zev,uod,vev,epsedn,epsodn,
     x                       snnp1ev,snnp1od,ls_node,
     x                       jcap, len_trie_ls,
     x                       len_trio_ls, ls_dim,
     x                       ls_max_node, rerth)

      use machine,  only: kind_evod, kind_phys
cc
      implicit none
cc
      real(kind=kind_evod)     dod(len_trio_ls,2)
      real(kind=kind_evod)     zev(len_trie_ls,2)
      real(kind=kind_evod)     uod(len_trio_ls,2)
      real(kind=kind_evod)     vev(len_trie_ls,2)
cc
      real(kind=kind_evod)  epsedn(len_trie_ls)
      real(kind=kind_evod)  epsodn(len_trio_ls)
cc
      real(kind=kind_evod) snnp1ev(len_trie_ls)
      real(kind=kind_evod) snnp1od(len_trio_ls)
      real(kind = kind_phys) rerth
cc
      integer              jcap, len_trie_ls, len_trio_ls
      integer              ls_dim, ls_max_node
      integer              ls_node(ls_dim,3)
cc
!cmr  ls_node(1,1) ... ls_node(ls_max_node,1) : values of l
!cmr  ls_node(1,2) ... ls_node(ls_max_node,2) : values of jbasev
!cmr  ls_node(1,3) ... ls_node(ls_max_node,3) : values of jbasod
cc
      integer              l,locl,n
cc
      integer              indev,indev1,indev2
      integer              indod,indod1,indod2
      integer              inddif
cc
      real(kind=kind_evod) rl
cc
      real(kind=kind_evod) cons0     !constant
cc
      integer              indlsev,jbasev
      integer              indlsod,jbasod
cc
      include 'function_indlsev'
      include 'function_indlsod'
cc
cc
cc......................................................................
cc
cc
      cons0 = 0.d0     !constant
cc
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
cc
         vev(indlsev(l,l),1) = cons0     !constant
         vev(indlsev(l,l),2) = cons0     !constant
cc
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         jbasod=ls_node(locl,3)
         indev1 = indlsev(l,l)
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap-1,l)
         else
            indev2 = indlsev(jcap  ,l)
         endif
         indod1 = indlsod(l+1,l)
         inddif = indev1 - indod1
cc
         do indev = indev1 , indev2
cc
            uod(indev-inddif,1) = -epsodn(indev-inddif)
     x                              * zev(indev,1)
cc
            uod(indev-inddif,2) = -epsodn(indev-inddif)
     x                              * zev(indev,2)
cc
         enddo
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         jbasod=ls_node(locl,3)
         indev1 = indlsev(l,l) + 1
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap+1,l)
         else
            indev2 = indlsev(jcap  ,l)
         endif
         indod1 = indlsod(l+1,l)
         inddif = indev1 - indod1
cc
         do indev = indev1 , indev2
cc
            vev(indev,1) = epsedn(indev)
     x                      * dod(indev-inddif,1)
cc
            vev(indev,2) = epsedn(indev)
     x                      * dod(indev-inddif,2)
cc
         enddo
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasod=ls_node(locl,3)
         indod1 = indlsod(l+1,l)
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indod2 = indlsod(jcap  ,l)
         else
            indod2 = indlsod(jcap+1,l) - 1
         endif
         if ( l .ge. 1 ) then
              rl = l
            do indod = indod1 , indod2
cc             u(l,n)=-i*l*d(l,n)/(n*(n+1))
cc
               uod(indod,1) = uod(indod,1)
     1                 + rl * dod(indod,2)
     2                  / snnp1od(indod)
cc
               uod(indod,2) = uod(indod,2)
     1                 - rl * dod(indod,1)
     2                  / snnp1od(indod)
cc
            enddo
         endif
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         indev1 = indlsev(l,l)
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap-1,l)
         else
            indev2 = indlsev(jcap  ,l)
         endif
         if ( l .ge. 1 ) then
              rl = l
            do indev = indev1 , indev2
cc             u(l,n)=-i*l*d(l,n)/(n*(n+1))
cc
               vev(indev,1) = vev(indev,1)
     1                 + rl * zev(indev,2)
     2                  / snnp1ev(indev)
cc
               vev(indev,2) = vev(indev,2)
     1                 - rl * zev(indev,1)
     2                  / snnp1ev(indev)
cc
            enddo
         endif
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         jbasod=ls_node(locl,3)
         indev1 = indlsev(l,l) + 1
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap-1,l)
         else
            indev2 = indlsev(jcap  ,l)
         endif
         indod1 = indlsod(l+1,l)
         inddif = indev1 - indod1
cc
         do indev = indev1 , indev2
cc
                 uod(indev-inddif,1) = uod(indev-inddif,1)
     1      + epsedn(indev)          * zev(indev       ,1)
cc
                 uod(indev-inddif,2) = uod(indev-inddif,2)
     1      + epsedn(indev)          * zev(indev       ,2)
cc
         enddo
cc
      enddo
cc
cc......................................................................
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         jbasod=ls_node(locl,3)
         indev1 = indlsev(l,l)
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap+1,l) - 1
         else
            indev2 = indlsev(jcap  ,l) - 1
         endif
         indod1 = indlsod(l+1,l)
         inddif = indev1 - indod1
cc
         do indev = indev1 , indev2
cc
                 vev(indev,1)      = vev(indev       ,1)
     1      - epsodn(indev-inddif) * dod(indev-inddif,1)
cc
                 vev(indev,2)      = vev(indev       ,2)
     1      - epsodn(indev-inddif) * dod(indev-inddif,2)
cc
         enddo
cc
      enddo
cc
cc......................................................................
cc
cc
      do locl=1,ls_max_node
              l=ls_node(locl,1)
         jbasev=ls_node(locl,2)
         jbasod=ls_node(locl,3)
         indev1 = indlsev(l,l)
         indod1 = indlsod(l+1,l)
         if (mod(l,2).eq.mod(jcap+1,2)) then
            indev2 = indlsev(jcap+1,l)
            indod2 = indlsod(jcap  ,l)
         else
            indev2 = indlsev(jcap  ,l)
            indod2 = indlsod(jcap+1,l)
         endif
         do indod = indod1 , indod2
cc
            uod(indod,1) = uod(indod,1) * rerth
            uod(indod,2) = uod(indod,2) * rerth
cc
         enddo
cc
         do indev = indev1 , indev2
cc
            vev(indev,1) = vev(indev,1) * rerth
            vev(indev,2) = vev(indev,2) * rerth
cc
         enddo
cc
      enddo
cc
      end subroutine gefs_dozeuv
