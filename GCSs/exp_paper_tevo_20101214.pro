;+
;*************************************************************************
; Francisco A. Iglesias - UTN-FRM/GEAA - franciscoaiglesias@frm.utn.edu.ar
;
; Reads all the .sav files containing the parameters of the fitted CGS model
; ,following Thernisien et. al. 2009, and plots them vs time.
; 
; History:
;	20180411 - First version
;*************************************************************************
;-
pro  exp_paper_tevo_20101214
@gcs_config


DIR=GCSD_PATH+'/GCS_20101214'

f=file_search(DIR+'/','*.sav')
nf=n_elements(f)
; stores relevant data from all .sav files in d struct
restore, f[0]
awl=2.*(sgui.HAN + asin(sgui.RAT)) *!RAdeg
awd=2.*asin(sgui.RAT)  *!RAdeg

d={awl:awl, awd:awd, hgt:sgui.HGT, rat:sgui.RAT, han:sgui.HAN *!RAdeg, rot:sgui.ROT*!RAdeg, lon:sgui.LON*!RAdeg , lat:sgui.LAT*!RAdeg,date:sgui.ERUPTIONDATE}
for i=1, nf-1 do begin
  restore, f[i]
  awl=2.*(sgui.HAN + asin(sgui.RAT)) *!RAdeg
  awd=2.*asin(sgui.RAT) *!RAdeg
  d=[d, {awl:awl, awd:awd, hgt:sgui.HGT, rat:sgui.RAT, han:sgui.HAN *!RAdeg, rot:sgui.ROT*!RAdeg, lon:sgui.LON*!RAdeg , lat:sgui.LAT*!RAdeg,date:sgui.ERUPTIONDATE}]
  print, sgui.ERUPTIONDATE
endfor
d=d[sort(d.date)] ; sorts by date

;delte last point 
;   stop
; d=d[0:nf-4]
;plots settings
mydevice = !D.NAME
SET_PLOT, 'PS'
DEVICE, FILENAME=GCSD_PATH+'/plots/20101214_allPar.eps',/encapsulated, /LANDSCAPE, XSIZE=10.2, YSIZE=7,/inches
!P.Multi = [0,3,2,0,1]
FONT=3.
MARGIN=[4,1]
XMARGIN=[7,1]
YLOG=0
!P.Color = '000000'xL
!P.Background = 'FFFFFF'xL

;Plots
time=str2utc(d.date)
time=float(time.time)/1000./3600.
;window, 2, xsize=1000, ysize=800
SYM=-5
LINE=1
bla=tim2carr(d[n_elements(d.date)-1].date); lon to carr
bla=d.lon-bla[0]
plot, time,  d.hgt, ylog=YLOG, psym=SYM,linestyle=LINE, ytitle='Height [Rs]', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Time of the day [h]', yrange=[min(d.hgt)*0.95,max(d.hgt)*1.05]
plot, d.hgt, bla, ylog=YLOG, psym=SYM,linestyle=LINE, ytitle='Longitude [deg]', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Height [Rs]', yrange=[min(bla)*0.95,max(bla)*1.05]
plot, d.hgt, d.rat, ylog=YLOG, psym=SYM,linestyle=LINE, ytitle='Aspect ratio', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Height [Rs]', yrange=[min(d.rat)*0.95,max(d.rat)*1.05]
plot, d.hgt, d.lat, psym=SYM,linestyle=LINE, ytitle='Latitude [deg]', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Height [Rs]', yrange=[min(d.lat)*0.95,max(d.lat)*1.05]
plot, d.hgt, d.han, ylog=YLOG, psym=SYM,linestyle=LINE, ytitle='Half angle [deg]', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Height [Rs]', yrange=[min(d.han)*0.95,max(d.han)*1.05]
plot, d.hgt, d.rot, ylog=YLOG, psym=SYM,linestyle=LINE, ytitle='Tilt angle [deg]', charsize=FONT, YMARGIN=MARGIN,xmargin=XMARGIN, $
      xtitle='Height [Rs]', yrange=[min(d.rot)*0.80, max(d.rot)*1.20]
; Close the PostScript file:
DEVICE, /CLOSE
SET_PLOT, mydevice

end