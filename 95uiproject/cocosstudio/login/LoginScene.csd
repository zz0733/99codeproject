<GameFile>
  <PropertyGroup Name="LoginScene" Type="Layer" ID="02f7d25e-607e-4fca-8e35-ce0f69b9a42a" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="1.0000" ActivedAnimationName="quan">
        <Timeline ActionTag="-1391326620" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="-0.0026" />
          <ScaleFrame FrameIndex="10" X="90.0000" Y="89.9974" />
          <ScaleFrame FrameIndex="20" X="180.0000" Y="179.9974" />
          <ScaleFrame FrameIndex="40" X="360.0000" Y="359.9974" />
        </Timeline>
        <Timeline ActionTag="628386222" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="-0.0035" />
          <ScaleFrame FrameIndex="10" X="90.0000" Y="89.9965" />
          <ScaleFrame FrameIndex="20" X="180.0000" Y="179.9965" />
          <ScaleFrame FrameIndex="30" X="270.0000" Y="269.9965" />
          <ScaleFrame FrameIndex="40" X="360.0000" Y="359.9965" />
        </Timeline>
        <Timeline ActionTag="-1955056196" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="10" X="-0.0290" Y="1.0000" />
          <ScaleFrame FrameIndex="20" X="-1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="-1955056196" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="quan" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="61" G="247" B="20" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Scene" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="Panel" ActionTag="-1496906733" Tag="174" IconVisible="True" TouchEnable="True" ClipAble="False" BackColorAlpha="102" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="Image_1" ActionTag="700475722" Tag="1007" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1.0240" RightMargin="-1.0240" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
                <Size X="1280.0000" Y="720.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="641.0240" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5008" Y="0.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="Normal" Path="login/image/loading/zcm_zjm_bg.jpg" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="nodeTitle" ActionTag="1893962865" Tag="209" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="sprite_logo" ActionTag="-645446572" Tag="1012" IconVisible="True" LeftMargin="-536.5000" RightMargin="-536.5000" TopMargin="-264.0000" BottomMargin="-114.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="1073.0000" Y="378.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position Y="75.0000" />
                    <Scale ScaleX="0.7000" ScaleY="0.7000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="login/image/loading/logo.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="nodeButton" ActionTag="-354551629" Tag="221" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="580.0000" BottomMargin="140.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="button_loginWeixin" ActionTag="-136260422" Tag="220" IconVisible="True" LeftMargin="-555.3111" RightMargin="221.3111" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="1523704710" Tag="222" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="36.5000" RightMargin="36.5000" TopMargin="17.5036" BottomMargin="25.4964" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="261.0000" Y="60.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="167.0000" Y="55.4964" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5388" />
                        <PreSize X="0.7814" Y="0.5825" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login1.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="-388.3111" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login1.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="0" R="0" G="0" B="0" />
                    <GlowColor R="0" G="63" B="198" A="255" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="button_loginAccount" ActionTag="1594853791" Tag="219" IconVisible="True" LeftMargin="-163.9473" RightMargin="-170.0527" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="-952422014" Tag="236" IconVisible="True" LeftMargin="15.0967" RightMargin="33.9033" TopMargin="14.1200" BottomMargin="22.8800" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="285.0000" Y="66.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="157.5967" Y="55.8800" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4718" Y="0.5425" />
                        <PreSize X="0.8533" Y="0.6408" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login2.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="3.0527" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login2.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="0" R="0" G="0" B="0" />
                    <GlowColor R="0" G="63" B="198" A="255" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="button_loginYouke" ActionTag="1978611480" Tag="237" IconVisible="True" LeftMargin="226.6805" RightMargin="-560.6805" TopMargin="-41.9700" BottomMargin="-61.0300" TouchEnable="True" FontSize="14" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="ButtonObjectData">
                    <Size X="334.0000" Y="103.0000" />
                    <Children>
                      <AbstractNodeData Name="title" ActionTag="1636566763" Tag="238" IconVisible="True" LeftMargin="14.8804" RightMargin="34.1196" TopMargin="14.1200" BottomMargin="22.8800" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                        <Size X="285.0000" Y="66.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="157.3804" Y="55.8800" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.4712" Y="0.5425" />
                        <PreSize X="0.8533" Y="0.6408" />
                        <FileData Type="Normal" Path="login/image/zcmdwc_loading/btntext_login3.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="393.6805" Y="-9.5300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/btn_login3.png" Plist="" />
                    <OutlineColor A="255" R="0" G="63" B="198" />
                    <ShadowColor A="0" R="0" G="0" B="0" />
                    <GlowColor R="0" G="63" B="198" A="255" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="640.0000" Y="140.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.1944" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="button_customBtn" ActionTag="788269485" VisibleForFrame="False" Tag="315" IconVisible="True" HorizontalEdge="RightEdge" VerticalEdge="TopEdge" LeftMargin="1188.0000" RightMargin="20.0000" BottomMargin="640.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="42" Scale9Height="58" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="ButtonObjectData">
                <Size X="72.0000" Y="80.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1224.0000" Y="680.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9563" Y="0.9444" />
                <PreSize X="0.0562" Y="0.1111" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="Normal" Path="login/image/zcmdwc_loading/icon_kefu.png" Plist="" />
                <OutlineColor A="255" R="0" G="63" B="198" />
                <ShadowColor A="0" R="0" G="0" B="0" />
                <GlowColor R="0" G="63" B="198" A="255" />
              </AbstractNodeData>
              <AbstractNodeData Name="text_version" ActionTag="2005517172" Tag="293" IconVisible="True" PositionPercentYEnabled="True" HorizontalEdge="RightEdge" LeftMargin="1263.9840" RightMargin="16.0160" TopMargin="670.8960" BottomMargin="49.1040" FontSize="20" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" AreaWidth="0" AreaHeight="0" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="TextObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="1263.9840" Y="49.1040" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9875" Y="0.0682" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
                <GlowColor R="0" G="0" B="0" A="255" />
              </AbstractNodeData>
              <AbstractNodeData Name="panel_loadPanel" ActionTag="1276492354" VisibleForFrame="False" Tag="288" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="540.0000" RightMargin="540.0000" TopMargin="421.8000" BottomMargin="148.2000" TouchEnable="True" ClipAble="False" BackColorAlpha="240" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
                <Size X="200.0000" Y="150.0000" />
                <Children>
                  <AbstractNodeData Name="Sprite_18" ActionTag="-1391326620" Tag="289" RotationSkewY="-0.0026" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/quan_bg.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_19" ActionTag="628386222" Alpha="159" Tag="290" RotationSkewY="-0.0035" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/quan.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_13" ActionTag="-1955056196" Tag="291" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="51.2200" RightMargin="49.7800" TopMargin="10.6200" BottomMargin="40.3800" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                    <Size X="99.0000" Y="99.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.7200" Y="89.8800" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5036" Y="0.5992" />
                    <PreSize X="0.4950" Y="0.6600" />
                    <FileData Type="Normal" Path="login/image/loading/tx.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="text_loadTip" ActionTag="634129480" Tag="292" IconVisible="True" PositionPercentXEnabled="True" LeftMargin="100.0000" RightMargin="100.0000" TopMargin="150.0000" FontSize="24" LabelText="" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" AreaWidth="0" AreaHeight="0" FontName="" GlowEnabled="False" BoldEnabled="False" UnderlineEnabled="False" ItalicsEnabled="False" StrikethroughEnabled="False" ctype="TextObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="100.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <OutlineColor A="255" R="0" G="0" B="0" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                    <GlowColor R="0" G="0" B="0" A="255" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="223.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.3100" />
                <PreSize X="0.1563" Y="0.2083" />
                <SingleColor A="255" R="150" G="200" B="255" />
                <FirstColor A="255" R="150" G="200" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>