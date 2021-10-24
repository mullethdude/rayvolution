// SPDX-License-Identifier: AGPL-1.0
pragma solidity 0.8.9;
pragma experimental ABIEncoderV2;

/* solhint-disable quotes */

import "./base/ERC721Base.sol";
import "./utils/Strings.sol";
import "./utils/Bytes.sol";
import "base64-sol/base64.sol";
import "hardhat/console.sol";

contract Rayvolutionize is ERC721Base {
    string internal constant TABLE_ENCODE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    uint256 internal constant SAMPLE_RATE = 11000;
    uint256 internal constant BYTES_PER_SAMPLE = 2;

    int256 internal constant ONE = 1000000;
    int256 internal constant TWO = 2000000; // 2 * ONE;
    int256 internal constant HALF = 500000; // ONE/ 2;
    int256 internal constant ZERO7 = 700000; // (ONE * 7) / 10;
    int256 internal constant ZERO3 = 300000; // (ONE * 3) / 10;
    int256 internal constant ZERO1 = 100000; //(ONE * 1) / 10;
    int256 internal constant ZERO3125 = 312500; //( ONE * 3125) / 10000;
    int256 internal constant ZERO8750 = 875000; // (ONE * 8750) / 10000;
    int256 internal constant MINUS_ONE = -1000000; //; -ONE;
    int256 internal constant MIN_VALUE = MINUS_ONE + 1;
    int256 internal constant MAX_VALUE = ONE - 1;

    int256 internal constant MINUS = -1;

    string internal _baseExternalUrl;
    address internal _maintainer;

    constructor(address maintainer) {
        // TODO string memory baseExternalUrl) {
        _maintainer = maintainer;
        // _baseExternalUrl = baseExternalUrl;
    }

    /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external pure returns (string memory) {
        return "Rayvolution, on-chain RayTracing Gif";
    }

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external pure returns (string memory) {
        return "RAY";
    }

    function tokenURI(uint256 id) external view returns (string memory) {
        return _tokenURI(id);
    }

    function mint(uint256 id, address to) external {
        require(to != address(0), "NOT_TO_ZEROADDRESS");
        require(to != address(this), "NOT_TO_THIS");
        address owner = _ownerOf(id);
        require(owner == address(0), "ALREADY_CALIMED");
        _safeTransferFrom(address(0), to, id, "");
    }


    bytes internal constant metadataStart =
        'data:application/json,{"name":"__________________________________","description":"RayTracing on Solidity","external_url":"?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????","image":"data:image/gif;base64,R0lGODlh';

    function prepareBuffer(bytes memory buffer) internal pure {
        unchecked{
        bytes memory start = metadataStart;
        uint256 len = metadataStart.length;
        uint256 src;
        uint256 dest;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            src := add(start, 0x20)
            dest := add(buffer, 0x20)
        }
        for (; len >= 32; len -= 32) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }
        // TODO remove that step by ensuring the length is a multiple of 32 bytes
        uint256 mask = 256**(32 - len) - 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
        }
    }

    bytes32 internal constant base64Alphabet_1 = 0x4142434445464748494A4B4C4D4E4F505152535455565758595A616263646566;
    bytes32 internal constant base64Alphabet_2 = 0x6768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F;

    function uint8ToBase64(uint24 v) internal pure returns (bytes1 s) {
        unchecked{
        if (v >= 32) {
            return base64Alphabet_2[v - 32];
        }
        return base64Alphabet_1[v];
        }
    }


    function hang64len(
        uint256 di3,
        bytes memory buffer,
        uint256 pos,
        uint256 lun
    ) internal view returns (uint256 s) {
        unchecked{
        for (uint256 i = 0; i < (lun * 4) / 3; i += 1) {
            uint256 a = di3 >> (8 * lun - (i + 1) * 6);
            a = a & 0x3f;
            buffer[pos++] = uint8ToBase64(uint24(a));
        }
        return pos;
        }
    }

    function palletteColorsRed(
        uint256 palsize,
        bytes memory buffer,
        uint256 pos
    ) internal view returns (uint256 s) {
        unchecked{
        //do not forget the previous 0x00 from ascene.spectratio to have 3 bytes
        uint256 temp = 0x00;
        for (uint256 i = 0; i < palsize; i += 1) {
            temp = temp << 8;
            temp += (i * 256) / palsize;
            temp = temp << 8;
            pos = hang64len(temp, buffer, pos, 3);

            temp = 0x00;
        }
        //because of ascene.spectratio bytes at the start add 2 first bytes of netscape to make

        //

        temp = temp << 8;
        temp += 0x21;
        temp = temp << 8;
        temp += 0xff;
        pos = hang64len(temp, buffer, pos, 3);
        return pos;
        }
    }

/*
    function gen64(
        uint256 palsize,
        bytes memory buffer,
        uint256 pos
    ) internal view returns (uint256 s) {
        unchecked{
        pos = hang64len(0xf90409aa0000002c00000000, buffer, pos, 12);

        pos = hang64len(0x400040000007, buffer, pos, 6);
        //0xf90409aa0000002c00000000130013000007
        //uint256 siz=palsize;
        uint256 temp = 0x4180;
        //uint256 count=2;
        //pos=hang64len(0x4280,buffer,pos,3);
        for (uint256 j = 0; j < palsize; j += 1) {
            temp = 0x4180;
            for (uint256 i = 0; i < palsize-1; i += 3) {
                temp = temp << 8;
                temp += raytracer(int256(i), int256(j));
                pos = hang64len(temp, buffer, pos, 3);
                temp = raytracer(int256(i + 1), int256(j));
                temp = temp << 8;
                temp += raytracer(int256(i + 2), int256(j));

            }
            temp = temp << 8;
            temp += raytracer(int256(63), int256(j));
            pos = hang64len(temp, buffer, pos, 3);
        }
      
        pos = hang64len(0x0181003b, buffer, pos, 6);
        return pos;
        }
    }

*/

    

   
    function scaleVector(int256 ax,
        int256 ay,
        int256 az, int256 sc) internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
        unchecked{
        sx=ax*sc;
        sy=ay*sc;
        sz=az*sc;
        return(sx,sy,sz);
        }
    }
    function divVector(int256 ax,
        int256 ay,
        int256 az, int256 sc) internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
             unchecked{
        sx=ax*1000000/sc;
        sy=ay*1000000/sc;
        sz=az*1000000/sc;
        return(sx,sy,sz);
             }
    }

    function unitVector(int256 ax,
        int256 ay,
        int256 az)internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
             unchecked{
        return divVector(ax,
        ay,
        az, lengthVector(ax,
        ay,
        az));
             }
    }

    function lengthVector(int256 ax,
        int256 ay,
        int256 az) internal view returns (int256 d) {
             unchecked{
        int256 ltemp=dotVector(ax,
        ay,
        az, ax,
        ay,
        az);
        return int256(sqrt(uint256(ltemp)));
             }
    }
function subVector(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz)internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
             unchecked{
    sx=ax-bx;
        sy=ay-by;
        sz=az-bz;
        return(sx,sy,sz);
             }
    
}


function crossVector(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz)internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
             unchecked{
            sx=(ay * bz) - (az * by);
        sy=(az * bx) - (ax * bz);
        sz=(ax * by) - (ay * bx);
        return(sx,sy,sz);
             }
}

function add3vector(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz,int256 cx,
        int256 cy,
        int256 cz) internal view returns (int256 sx,
        int256 sy,
        int256 sz){
            
 unchecked{
            sx=ax+bx+cx;
        sy=ay+by+cy;
        sz=az+bz+cz;
        return(sx,sy,sz);
 }
}

function addvector(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz)internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
            unchecked{
    sx=ax+bx;
        sy=ay+by;
        sz=az+bz;
        return(sx,sy,sz);
        }
    
}
    function sqrt(uint256 x) internal view returns (uint256 y) {
        unchecked{
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        }
    }

    function dotVector(
        int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz
    ) internal view returns (int256 d) {
        unchecked{
        return ((ax * bx) + (ay * by) + (az * bz));
        }
    }

    function reflectThrough(
        int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz
    ) internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
            unchecked{
  (int dx ,int dy, int dz) = scaleVector(ax,ay,az, dotVector(ax,ay,az, bx,by,bz));
  (dx,dy,dz)=scaleVector(dx,dy,dz, 2);
        return subVector(dx,dy,dz, ax,ay,az);
    }}

function sphereNormal(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz) internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
            unchecked{
            (int dx ,int dy, int dz) = subVector(ax,ay,az, bx,by,bz);
  return unitVector(dx,dy,dz);
            }
}


     struct Vector {
        int camx;
        int camy;
        int camz;
        int fov;
        int camvecx;
        int camvecy;
        int camvecz;
        int lightx;
        int lighty;
        int lightz;
        int sphx;
        int sphy;
        int sphz;
        int colr;
        int spec;
        int lamb;
        int amb;
        int radi;
        int eVx;
        int eVy;
        int eVz;
        int vRx;
        int vRy;
        int vRz;
        int vUx;
        int vUy;
        int vUz;
        int xtx;
        int xty;
        int xtz;
        int ytx;
        int yty;
        int ytz;
        int rAx;
        int rAy;
        int rAz;
        int dist;
        int obj;
        int lvx;
        int lvy;
        int lvz;
        int snx;
        int sny;
        int snz;
        int discr;
        int vale;
    }

function encounterScene(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz,
        int256 cx,
        int256 cy,
        int256 cz,
        int256 rad)internal view returns (int256 sx,
        int256 sy,
        int256 sz){
            unchecked{

        (int dist,int vale)= intersecObject(ax,ay,az,bx,by,bz,cx,cy,cz,rad);

    return (dist,0,vale);
            }
  }

  function intersecObject(int256 ax,
        int256 ay,
        int256 az,
        int256 bx,
        int256 by,
        int256 bz,
        int256 cx,
        int256 cy,
        int256 cz,
        int256 rad)internal view returns (int256 sx,int256 sy){
            unchecked{
    (int ecx, int ecy,int ecz) = subVector(ax,ay,az,bx,by,bz);
    int vale = dotVector(ecx,ecy,ecz,cx,cy,cz)/1000000000;
    int eco = dotVector(ecx,ecy,ecz,ecx,ecy,ecz)/1000000;
    rad=rad/1000;
    return ((rad * rad - eco + vale * vale),vale);
        }
  }
        function rescaleVector(int256 ax,
        int256 ay,
        int256 az, int256 sc) internal view returns (int256 sx,
        int256 sy,
        int256 sz) {
        unchecked{
        sx=ax*sc/1000000;
        sy=ay*sc/1000000;
        sz=az*sc/1000000;
        return(sx,sy,sz);
        }
    }
    function raytracer(int256 x, int256 y, int256 coolor) internal view returns (uint256 col) {
        unchecked{
        Vector memory scene= Vector({camx:1000000,camy:2000000,camz:11000000,fov:45000000,camvecx:2000000,camvecy:6000000,camvecz:-15000000,lightx:-20000000,lighty:10000000,lightz:10000000,sphx:1000000,sphy:4000000,sphz:-5000000,colr:128,spec:25000000,lamb:800000,amb:150000,radi:3000000,eVx:0,eVy:0,eVz:0,vRx:0,vRy:0,vRz:0,vUx:0,vUy:0,vUz:0,xtx:0,xty:0,xtz:0,ytx:0,yty:0,ytz:0,rAx:0,rAy:0,rAz:0,dist:0,obj:0,lvx:0,lvy:0,lvz:0,snx:0,sny:0,snz:0,discr:0,vale:0});
        
        (scene.eVx,scene.eVy,scene.eVz)=subVector(scene.camvecx,scene.camvecy,scene.camvecz,scene.camx,scene.camy,scene.camz);
        (scene.eVx,scene.eVy,scene.eVz)=unitVector(scene.eVx,scene.eVy,scene.eVz);
        
        (scene.vRx,scene.vRy,scene.vRz)=crossVector(scene.eVx,scene.eVy,scene.eVz,0,1000000,0);
        (scene.vRx,scene.vRy,scene.vRz)=unitVector(scene.vRx,scene.vRy,scene.vRz);
        (scene.vUx,scene.vUy,scene.vUz)=crossVector(scene.vRx,scene.vRy,scene.vRz,scene.eVx,scene.eVy,scene.eVz);
        (scene.vUx,scene.vUy,scene.vUz)=unitVector(scene.vUx,scene.vUy,scene.vUz);
        scene.colr=coolor;

       //fovRadians = 392699
          //halfWidth =          414213
          //camerawidth =828426
          //pixelWidth=13149
        (scene.xtx,scene.xty,scene.xtz)= rescaleVector(scene.vRx,scene.vRy,scene.vRz, x * 55228 - 414213);
        (scene.ytx,scene.yty,scene.ytz)= rescaleVector(scene.vUx,scene.vUy,scene.vUz, y * 55228 - 414213);

        (scene.rAx,scene.rAy,scene.rAz)=add3vector(scene.eVx,scene.eVy,scene.eVz, scene.xtx,scene.xty,scene.xtz, scene.ytx,scene.yty,scene.ytz);
        (scene.rAx,scene.rAy,scene.rAz)=unitVector(scene.rAx,scene.rAy,scene.rAz);
        
        ( scene.discr, scene.obj,scene.vale)=encounterScene(scene.sphx,scene.sphy,scene.sphz,scene.camx,scene.camy,scene.camz,scene.rAx,scene.rAy,scene.rAz,scene.radi);
        if (scene.discr < 0) {
            return 0;
        }

        (int px, int py,int pz) = scaleVector(scene.rAx,scene.rAy,scene.rAz,scene.vale - int(sqrt(uint(scene.discr))));
        (px,py,pz)=addvector(scene.camx,scene.camy,scene.camz, px,py,pz);
        (scene.lvx,scene.lvy,scene.lvz)=subVector(px,py,pz,scene.lightx,scene.lighty,scene.lightz);
        (scene.lvx,scene.lvy,scene.lvz)=unitVector(scene.lvx,scene.lvy,scene.lvz);
        (scene.discr, scene.obj, scene.vale)=encounterScene(scene.sphx,scene.sphy,scene.sphz,px,py,pz,scene.lvx,scene.lvy,scene.lvz,scene.radi);

        (scene.snx,scene.sny,scene.snz)=sphereNormal(scene.sphx,scene.sphy,scene.sphz,px,py,pz);
        scene.spec=0;
        scene.vale=scene.vale - int(sqrt(uint(scene.discr)));
        int cont=0;
        if(scene.vale>-5000){
            (px,py,pz)=subVector(scene.lightx,scene.lighty,scene.lightz,px,py,pz);
            (px,py,pz)=unitVector(px,py,pz);
            cont=dotVector(px,py,pz,scene.snx,scene.sny,scene.snz);
            
        }
        if (cont > 1000000) {
                scene.spec = cont;  
            }
            else{
                scene.spec = 1000000;
            }
        scene.colr=scene.colr*scene.spec/1000000*scene.lamb/1000000+scene.colr*scene.amb/1000000;
  
            return uint(scene.colr);
    }
    }


    function _tokenURI(uint256 id) internal view returns (string memory) {
        unchecked{
        bytes memory buffer = new bytes(metadataStart.length + 500000);
        uint256 pos = metadataStart.length;
        prepareBuffer(buffer);

        //console.logInt(int(raytracer(15,15)));

        //PALETTE GENERATED
        //00 000000000000 21ff
        /*
        pos = hang64len(0x40004000f600, buffer, pos, 6);
        pos = palletteColorsRed(128, buffer, pos);
        pos = hang64len(0x0b4e45545343415045322e300301ffff0021, buffer, pos, 18);

        pos = gen64(64, buffer, pos);*/

        pos = hang64len(0x10001000f600, buffer, pos, 6);
        pos = palletteColorsRed(128, buffer, pos);
        pos = hang64len(0x0b4e45545343415045322e300301ffff0021, buffer, pos, 18);
        pos = gen16(16, buffer, pos);

        buffer[pos++] = 0x22;
        buffer[pos++] = 0x7D;
        console.log(string(buffer));

        assembly {
            mstore(buffer, pos)
        }
        //return string(buffer);
        }
    }

    function gen16(
        uint256 palsize,
        bytes memory buffer,
        uint256 pos
    ) internal view returns (uint256 s) {
        unchecked{
        pos = hang64len(0xf90409aa0000002c00000000, buffer, pos, 12);
        pos = hang64len(0x100010000007, buffer, pos, 6);
        uint256 temp = 0x1180;
        for (uint256 j = 0; j < palsize; j += 1) {
            temp = 0x1180;
            for (uint256 i = 0; i < palsize-1; i += 3) {
                temp = temp << 8;
                temp += raytracer(int256(i), int256(j),120);
                pos = hang64len(temp, buffer, pos, 3);
                temp = raytracer(int256(i + 1), int256(j),120);
                temp = temp << 8;
                temp += raytracer(int256(i + 2), int256(j),120);
            }
            temp = temp << 8;
            temp += raytracer(int256(15), int256(j),120);
            pos = hang64len(temp, buffer, pos, 3);
        }
        
         pos = hang64len(0x018100, buffer, pos, 3);
         pos = hang64len(0x21f90409aa0000002c000000, buffer, pos, 12);
         pos = hang64len(0x001000100000, buffer, pos, 6);
         temp=0x07;
        for (uint256 j = 0; j < palsize; j += 1) {
            temp = temp << 8;
             temp +=0x11;
             temp = temp << 8;
             temp +=0x80;
             pos = hang64len(temp, buffer, pos, 3);
            for (uint256 i = 0; i < palsize-1; i += 3) {
                
                temp = raytracer(int256(i), int256(j),60);//1
                temp = temp << 8;
                temp += raytracer(int256(i+1), int256(j),60);//55
                temp = temp << 8;
                temp +=raytracer(int256(i+2), int256(j),60);//77
                pos = hang64len(temp, buffer, pos, 3);
            }
            temp = raytracer(int256(15), int256(j),60);
        }
            temp = temp << 8;
             temp +=0x01;
             temp = temp << 8;
             temp +=0x81;
             pos = hang64len(temp, buffer, pos, 3);
         pos = hang64len(0x0021f90409aa0000002c0000, buffer, pos, 12);
         pos = hang64len(0x000010001000, buffer, pos, 6);
         temp=0x0007;
        for (uint256 j = 0; j < palsize; j += 1) {
            temp = temp << 8;
             temp +=0x11;
             pos = hang64len(temp, buffer, pos, 3);
             temp = 0x80;
             temp = temp << 8;
             
            for (uint256 i = 0; i < palsize-1; i += 3) {
                
                temp += raytracer(int256(i), int256(j),120);//1
                temp = temp << 8;
                temp += raytracer(int256(i+1), int256(j),60);//55
                pos = hang64len(temp, buffer, pos, 3);
                temp =raytracer(int256(i+2), int256(j),30);//77
                temp = temp << 8;
            }
            temp += raytracer(int256(15), int256(j),120);
        }
        temp = temp << 8;
        temp +=0x01;
        pos = hang64len(temp, buffer, pos, 3);
        temp =0x81;
        temp = temp << 8;
        temp += 0x00;
        temp = temp << 8;
        temp +=0x3b;
        pos = hang64len(temp, buffer, pos, 3);
        return pos;
        }
    }
}
