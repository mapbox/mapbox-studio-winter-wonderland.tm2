// Languages: name (local), name_en, name_fr, name_es, name_de
@name: '[name]';

// Common Colors //

@land: #f7f7f7;
@water: #cdd;
@water_dark: #185869;
@green: #cdb;
@crop: #eeeed4;
@grass: #e7ebd1;
@scrub: #A0C49F;
@wood: #d4e2c6;
@snow: #fff;

@cemetery: mix(@green,@land,30);
@pitch: @land;
@park: @land;
@piste: mix(blue,@land,5);

@built-up: mix(#ddd,@land,20);
@rock: #ddd;
@sand: #f0eacc;
@school: #f6ecd6;

// Background //

Map {
  background-color: @land;
}

// Landcover //

#landcover {
  [class='wood'] {
  [zoom>=4] { polygon-fill: lighten(@wood,11); }
  [zoom>=8] {
    polygon-fill: transparent;
    polygon-pattern-file: url(img/wood_12.png);
    }
  [zoom>=17] {
    polygon-fill: transparent;
    polygon-pattern-file: url(img/wood_18.png);
    }
  }
  [zoom>=4] {
  [class='scrub'] { polygon-fill: lighten(@scrub,27); }
  [class='grass'] { polygon-fill: lighten(@grass,13); }
  [class='crop'] { polygon-fill: lighten(@crop,13); }
  [class='snow'] { polygon-fill: @snow; }
  // fade out stronger classes at high zooms,
  // let more detailed OSM data take over a bit:
  [class='wood'][zoom>=14],
  [class='scrub'][zoom>=15],
  [class='grass'][zoom>=16] {
    [zoom>=14] { polygon-opacity: 0.8; }
    [zoom>=15] { polygon-opacity: 0.6; }
    [zoom>=16] { polygon-opacity: 0.4; }
    [zoom>=17] { polygon-opacity: 0.2; }
  }
  }
}

// Landuse areas //

#landuse {
  polygon-fill: rgba(0,0,0,0);
  polygon-clip: false;
  [class='crop'] { polygon-fill: @crop; }
  [class='park'] { polygon-fill: @park; }
  [class='cemetery'] { polygon-fill: @cemetery; }
  [class='industrial'] { polygon-fill: @built-up; }
  [class='school'] { polygon-fill: mix(@land,@school,40);}
  [type='golf_course'],[type='rough'] { polygon-fill: @land; }
  [class='pitch'][zoom>=15] {
    polygon-fill: @land;
    line-color: lighten(@green,5);
    line-width: 0.5;
    [zoom>=16] { line-width: 1; }
  }
  [class='sand'] {
    [type='bunker'] {
      line-color: mix(@sand,@land,100);
    }
  }
}

#landuse_overlay {
  polygon-fill: rgba(0,0,0,0);
  polygon-clip: false;
  [class='wetland'] {
    polygon-fill: fadeout(@water,80);
    [zoom>=12] {
      polygon-pattern-file: url(img/wetland_16.png);
      polygon-pattern-opacity: 0.5;
      polygon-pattern-alignment: global;
    }
    [zoom>=13] { polygon-pattern-file: url(img/wetland_32.png); }
    [zoom>=14] { polygon-pattern-file: url(img/wetland_64.png); }
  }
  [class='wetland_noveg'] {
    polygon-fill: fadeout(@water,80);
    [zoom>=12] {
      polygon-pattern-file: url(img/wetland_noveg_16.png);
      polygon-pattern-opacity: 0.5;
      polygon-pattern-alignment: global;
    }
    [zoom>=13] { polygon-pattern-file: url(img/wetland_noveg_32.png); }
    [zoom>=14] { polygon-pattern-file: url(img/wetland_noveg_64.png); }
  }
  [class='breakwater'],
  [class='pier'] {
    polygon-fill: @land;
  }
}

// Hillshading //

#hillshade {
  ::0[zoom<=13],
  ::1[zoom=14],
  ::2[zoom>=15][zoom<=16],
  ::3[zoom>=17][zoom<=18],
  ::4[zoom>=19] {
    comp-op: hard-light;
    polygon-clip: false;
    image-filters-inflate: true;
    [class='full_shadow'] {
      polygon-fill: #003d5c ;
      polygon-opacity: 0.15;
      [zoom>=15][zoom<=16] { polygon-opacity: 0.075; }
      [zoom>=17][zoom<=18] { polygon-opacity: 0.05; }
      [zoom>=18] { polygon-opacity: 0.025; }
    }
    [class='medium_shadow'] {
      polygon-fill: #036;
      polygon-opacity: 0.15;
      [zoom>=15][zoom<=16] { polygon-opacity: 0.075; }
      [zoom>=17][zoom<=18] { polygon-opacity: 0.05; }
      [zoom>=18] { polygon-opacity: 0.025; }
    }
    [class='medium_highlight'] {
      polygon-fill: #ffb;
      polygon-opacity: 0.2;
      [zoom>=15][zoom<=16] { polygon-opacity: 0.3; }
      [zoom>=17][zoom<=18] { polygon-opacity: 0.2; }
      [zoom>=18] { polygon-opacity: 0.1; }
    }
    [class='full_highlight'] {
      polygon-fill: #ffd;
      polygon-opacity: 0.25;
      [zoom>=15][zoom<=16] { polygon-opacity: 0.3; }
      [zoom>=17][zoom<=18] { polygon-opacity: 0.2; }
      [zoom>=18] { polygon-opacity: 0.1; }
    }
  }
  ::1 { image-filters: agg-stack-blur(2,2); }
  ::2 { image-filters: agg-stack-blur(8,8); }
  ::3 { image-filters: agg-stack-blur(16,16); }
  ::4 { image-filters: agg-stack-blur(32,32); }
}

// Elevation contours & labels //

// Multiple copies of the same layer have been made, each with
// unique classes and positions in the stack. This is done by
// editing the layers list in <project.yml>.

#contour.line::line {
  line-color: #048;
  line-opacity: 0.1;
  line-width: 1.2;
  [index>=5] {
    line-opacity: 0.2;
    line-width: 1.2;
  }
}

#contour.label::label[ele!=0] {
  [zoom<=12][index>=5],
  [zoom>=13][zoom<=15][index=10],
  [zoom>=16][index>=5] {
    text-name: "[ele]+' m'";
    text-face-name: 'Open Sans Regular';
    text-placement: line;
    text-size: 10;
    text-fill: darken(#D8E1EB,25);
    text-avoid-edges: true;
    text-halo-fill: lighten(#048,75);
    text-halo-radius: 2;
    text-halo-rasterizer: fast;
    opacity: 1;
  }
  [zoom>=14] {
    opacity: .2;
  }
}

// Water Features //

#water {
  polygon-clip: false;
  polygon-fill: @water_dark;
  ::blur {
    // A second attachment that is blurred creates the effect of
    // an inline stroke on the water layer.
    image-filters: agg-stack-blur(1,1);
    image-filters-inflate: true;
    polygon-clip: false;
    polygon-fill: @water;
    polygon-gamma: 0.6;
    [zoom<6] { polygon-gamma: 0.4; }
      polygon-pattern-file: url(img/ice_24.png);
      [zoom>=16] { polygon-pattern-file: url(img/ice_32.png); }
      [zoom>=18] { polygon-pattern-file: url(img/ice_64.png); }
  }
}

#waterway {
  [type='river'],
  [type='canal'] {
    line-color: mix(@water,@water_dark,70);
    line-width: 0.5;
    [zoom>=12] { line-width: 1; }
    [zoom>=14] { line-width: 1.5; line-cap: round; line-smooth: 0.5; }
    [zoom>=16] { line-width: 2; }
  }
  [type='stream'] {
    line-color: mix(@water,@water_dark,70);
    line-width: 0.25;
    [zoom>=14] { line-width: 1; line-smooth: 0.5; }
    [zoom>=16] { line-width: 1.5; line-cap: round; }
    [zoom>=18] { line-width: 2; }
  }
}

// Aeroways //

// lines
#aeroway['mapnik::geometry_type'=2][zoom>9] {
  [type='runway'] {
    line-color:#ddd;
  	line-cap:square;
  	line-join:miter;
    [zoom=10]{ line-width:1; }
    [zoom=11]{ line-width:2; }
    [zoom=12]{ line-width:3; }
    [zoom=13]{ line-width:5; }
    [zoom=14]{ line-width:7; }
    [zoom=15]{ line-width:11; }
    [zoom=16]{ line-width:15; }
    [zoom=17]{ line-width:19; }
    [zoom>17]{ line-width:23; }
  }
  [type='taxiway'][zoom>=12] {
    line-color:#ddd;
  	line-cap:square;
  	line-join:miter;
    [zoom=10]{ line-width:0.2; }
    [zoom=11]{ line-width:0.2; }
    [zoom=12]{ line-width:0.2; }
    [zoom=13]{ line-width:1; }
    [zoom=14]{ line-width:1.5; }
    [zoom=15]{ line-width:2; }
    [zoom=16]{ line-width:3; }
    [zoom=17]{ line-width:4; }
    [zoom>17]{ line-width:5; }
  }
}

// polygons
#aeroway[type!='apron']['mapnik::geometry_type'=3][zoom>=13] {
  polygon-clip: false;
  polygon-fill: #ddd;
}

// Buildings //

#building {
  ::shadow[zoom>=16] {
    polygon-clip: false;
    polygon-fill: @land * 0.88;
  }
  polygon-clip: false;
  polygon-fill: mix(@main,#fff,52);
  [zoom>=16] {
    polygon-geometry-transform: translate(-0.5,-1.2);
  }
}

#barrier_line {
  [class='gate'][zoom>=17] {
    line-width:2.5;
    line-color:#aab;
  }
  [class='fence'][zoom>=17] {
    line-color: @land * 0.66;
    [zoom=17] { line-width:0.6; }
    [zoom=18] { line-width:0.8; }
    [zoom>18] { line-width:1; }
  }
  [class='hedge'][zoom>=16] {
    line-width:2.4;
    line-color:darken(@park,20);
    [zoom=16] { line-width: 0.6; }
    [zoom=17] { line-width: 1.2; }
    [zoom=18] { line-width: 1.4; }
    [zoom>18] { line-width: 1.6; }
  }
  [class='land'][zoom>=14] {
    ['mapnik::geometry_type'=2] {
      // These shouldn't be scaled based on pixel scaling
      line-color:@land;
      [zoom=14] { line-width: 0.4; }
      [zoom=15] { line-width: 0.75; }
      [zoom=16] { line-width: 1.5; }
      [zoom=17] { line-width: 3; }
      [zoom=18] { line-width: 6; }
      [zoom=19] { line-width: 12; }
      [zoom=20] { line-width: 24; }
      [zoom>20] { line-width: 48; }
    }
    ['mapnik::geometry_type'=3] {
      polygon-clip: false;
      polygon-fill:@land;
    }
  }
  [class='cliff'][zoom>=12] {
    line-color: #987;
    a/line-color: #987;
    a/line-width: 4;
    a/line-dasharray: 0,7,1,7;
    a/line-offset: -2;
  }
}

// Political boundaries //

#admin {
  line-join: round;
  line-color: #88a;
  [maritime=1] { line-color: darken(@water, 3%); }
  // Countries
  [admin_level=2] {
    [zoom=2] { line-width: 0.4; }
    [zoom=3] { line-width: 0.8; }
    [zoom=4] { line-width: 1; }
    [zoom=5] { line-width: 1.5; }
    [zoom>=6] { line-width: 2; }
    [zoom>=8] { line-width: 3; }
    [zoom>=10] { line-width: 4; }
    [disputed=1] { line-dasharray: 4,4; }
  }
  // States / Provices / Subregions
  [admin_level>=3] {
    line-width: 0.4;
    line-dasharray: 10,3,3,3;
    [zoom>=6] { line-width: 1; }
    [zoom>=8] { line-width: 2; }
    [zoom>=12] { line-width: 3; }
  }
}