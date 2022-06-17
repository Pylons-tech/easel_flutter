const List kTutorialItems = [
  {
    'header': 'Upload your NFT file',
    'description': 'Choose the file you wish to mint into a NFT!',
    'image': 'assets/images/tutorial1.png'
  },
  {
    'header': 'Edit your NFT Details',
    'description': 'Enter information describing your NFT including the price you wish to sell it for!',
    'image': 'assets/images/tutorial2.png'
  },
  {
    'header': 'Manage your NFT with the ',
    'header1': 'Pylons app',
    'description': 'You can store, collect & manage all your NFTs in the Pylons app!',
    'image': 'assets/images/tutorial3.png'
  },
];

/// ```PNG assets
const kShareIcon = 'assets/images/share_ic.png';
const kSaveIcon = 'assets/images/save_ic.png';
const kTooltipBalloon = 'assets/images/tooltip_balloon.png';
const kIconDenomUsd = 'assets/images/denom_usd.png';
const kIconDenomPylon = 'assets/images/denom_pylon.png';
const kIconDenomAtom = 'assets/images/denom_atom.png';
const kIconDenomEmoney = 'assets/images/denom_emoney.png';
const kIconDenomAgoric = 'assets/images/denom_agoric.png';
const kIconDenomJuno = 'assets/images/denom_juno.png';
const kTextFieldSingleLine = 'assets/images/text_field_single_line.png';
const kTextFieldMultiLine = 'assets/images/text_field_multi_line.png';
const kTextFieldButton = 'assets/images/text_field_button.png';
const kPreviewGradient = 'assets/images/preview_gradient.png';
const kAlertIcon = 'assets/images/svg/i_icon.svg';

/// ```SVG assets
const kSvgSplash = 'assets/images/svg/splash.svg';
const kSvgTabSplash = 'assets/images/svg/background_tab.svg';
const kSplashTabEasel = 'assets/images/svg/easel_tab.svg';
const kSplashNFTCreatorTab = 'assets/images/svg/nft_creator_tab.svg';
const kSvgRectBlue = 'assets/images/svg/rectangular_button_blue.svg';
const kSvgRectRed = 'assets/images/svg/rectangular_button_red.svg';
const kSvgDashedBox = 'assets/images/svg/dashed_box.svg';
const kSvgFileUpload = 'assets/images/svg/file_upload.svg';
const kSvgUploadErrorBG = 'assets/images/svg/upload_error_background.svg';
const kSvgCloseIcon = 'assets/images/svg/close_icon.svg';
const kSvgCloseButton = 'assets/images/svg/close_button.svg';
const kSvgNftFormatImage = 'assets/images/svg/nft_format_image.svg';
const kSvgNftFormatVideo = 'assets/images/svg/nft_format_video.svg';
const kSvgNftFormat3d = 'assets/images/svg/nft_format_3d.svg';
const kSvgNftFormatAudio = 'assets/images/svg/nft_format_audio.svg';
const kSvgMoreOption = 'assets/images/svg/more_options.svg';

/// ```URL constants
const ipfsDomain = 'https://ipfs.io/ipfs';
const kPlayStoreUrl = 'https://play.google.com/store/apps/details?id=tech.pylons.wallet';
const kWalletIOSId = 'xyz.pylons.wallet';
const kWalletAndroidId = 'tech.pylons.wallet';
const kWalletWebLink = 'https://wallet.pylons.tech';
const kWalletDynamicLink = 'pylons.page.link';

/// ```Number constants
const kMinNFTName = 9;
const kMinDescription = 20;
const kMinValue = 1;
const kMaxDescription = 256;
const kMaxEdition = 10000;
const kMinRoyalty = 0;
const kMaxRoyalty = 99.99;
const kFileSizeLimitInGB = 32;
const kMaxPriceLength = 14;
const kSecInMillis = 1000;
const double TABLET_MIN_WIDTH = 600;

/// ````Reserved words, symbols, IDs etc
const kCookbookId = 'cookbook_id';
const kUsername = 'username';
const kArtistName = 'artistName';

const kPylonSymbol = 'upylon';
const kUsdSymbol = 'ustripeusd';
const kAtomSymbol = 'uatom';
const kEuroSymbol = 'eeur';
const kAgoricSymbol = 'urun';
const kJunoSymbol = 'ujunox';

const kPylonText = 'Pylon';
const kUSDText = 'USD';
const kAtomText = 'Atom';
const kEurText = 'EEur';
const kAgoricText = 'Agoric';
const kJunoText = 'Juno';

/// ```Text constants
const kPreviewNoticeText = 'The resolution & orientation of your NFT will remain fixed as seen in the grid.';
const kPriceNoticeText = 'You can remove an active listing or revise the price of your NFT in your Pylons wallet';
const kNameAsArtistText = 'Your name as the artist';
const kGiveNFTNameText = 'Give your NFT a name';
const kEnterArtistNameText = 'Enter artist name';
const kEnterNFTNameText = 'Enter NFT name';
const kNameShouldHaveText = 'NFT name should have';
const kCharactersOrMoreText = 'characters or more';
const kDescribeYourNftText = 'Describe your NFT';
const kEnterNFTDescriptionText = 'Enter NFT description';
const kPriceText = 'Price';
const kEnterPriceText = 'Enter price';
const kEnterEditionText = 'Enter number of editions';
const kNoOfEditionText = 'Number of editions';
const kEnterRoyaltyText = 'Enter royalty in percentage';
const kRoyaltiesText = 'Royalties';
const kRoyaltyHintText = '5%';
const kRoyaltyNoteText =
    'Percentage of all secondary market sales automatically distributed to the NFT creator.\nTo opt out set value to';
const kRoyaltyRangeText = 'Allowed royalty is between';
const kMinIsText = 'Minimum is';
const kMaxIsTextText = 'Maximum is';
const kCharacterLimitText = 'character limit';
const kEnterMoreThanText = 'Enter more than';
const kCharactersText = 'characters';
const kMaxText = 'maximum';
const kOkText = 'Ok';
const kPylonsAppNotInstalledText = 'Pylons app is not installed on this device. Please install Pylons app to continue';
const kClickToInstallText = 'Click here to install';
const kClickToLogInText = 'Click here to log into Pylons';
const kWelcomeToEaselText = 'Welcome to Easel,';
const kEaselDescriptionText =
    'Easel is a NFT minter that allows you to create NFTs from any mobile device!\n\nOnce you successfully upload an audio, video or image file, enter the required information and press “Publish”, your file is transformed into a NFT that is stored on the Pylons blockchain indefinitely!\n\nYou’ll be able to view your new NFT in the Easel folder located in your Pylons Wallet.';
const kCreatedByText = 'Created by';
const kNftDetailsText = 'NFT Details';
const kDescribeText = 'Describe';
const kSizeText = 'Size';
const kDurationText = 'Duration';
const kDateText = 'Date';
const kRoyaltyText = 'Royalty';
const kPreview3dModelText = 'Click here to preview\nyour selected 3D Model';
const kMintMoreText = 'Mint More';
const kGoToWalletText = 'Go to Wallet';
const kChooseNFTFormatText = 'Choose your NFT format';
const kUploadNFTText = 'Upload NFT file';
const kDescribeNftText = 'Describe NFT';
const kPriceNftText = 'Price NFT';
const kUploadText = 'Upload';
const kPreviewText = 'Preview';
const kListText = 'List';
const kImageText = 'Image';
const kVideoText = 'Video';
const kAudioText = 'Audio';
const k3dText = '3D';
const kGetStarted = 'Get Started';
const kContinue = 'Continue';
const kWhyAppNeeded = 'Why the app is\nneeded?        \u21E9';
const kDownloadPylons = 'Download Pylons app';
const kWhyAppNeededDesc1 = 'Your Pylons app is your gateway to the Pylons ecosystem';
const kWhyAppNeededDescSummary1 = 'Discover new NFTs, apps & adventures';
const kWhyAppNeededDesc2 = 'It makes managing your crypto easy';
const kWhyAppNeededDescSummary2 = 'No frills. No complexities. One wallet  address for all your crypto';
const kWhyAppNeededDesc3 = 'You can always delete it if you’d like';
const kWhyAppNeededDescSummary3 =
    'No subscriptions. We don’t sell your information. We only charge a fee when you purchase a NFT';
const kPylonsAlreadyInstalled = 'Pylons already installed.';
const kTapToSelect = 'Tap to Select';
const kCloseText = 'Close';
const kUploadHint2 = '• Image, Video, 3D or Audio';
const kUploadHint3 = '• One file per upload';
const kUploadHintAll = 'GB Limit.\nOne file per upload.';
const kHintNftName = 'Bird on Shoulder';
const kHintArtistName = 'Sarah Jackson';
const kHintNftDesc =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eimod tempor incididunt ut labore et dolore magna aliquaQ. Ut enim ad minim veniam, quis nostrud exercita.';
const kHintNoEdition = '100';
const kHintPrice = '10.87';
const kHintHashtag = 'Type in';
const kHashtagsText = 'Hashtags (optional)';
const kAddText = 'Add';
const kNetworkFeeWarnText = 'A network fee of 10% of the listed price is required for all transactions that occur on-chain';

const kRecipeCreated = 'Recipe created';
const kErrProfileNotExist = 'profileDoesNotExist';
const kErrProfileFetch = 'Error occurred while fetching wallet profile';
const kErrUpload = 'Upload error occurred';
const kErrFileNotPicked = 'Pick a file';
const kErrUnsupportedFormat = 'Unsupported format';
const kErrFileMetaParse = 'Error occurred while parsing the chosen media file:';
const kErrRecipe = 'Recipe error :';
const kErrNoStripeAccount = 'Kindly register Stripe account in wallet';
const kTryAgain = "Try again";
const kAppNotInstalled = "Please download the Pylons app and create a username to publish a NFT in Easel.";
const kPleaseTryAgain = "Something went wrong.\n Please try again.";
const kCancel = "Cancel";


/// Nft viewmodel key values
const String kNameKey = "Name";
const String kNftUrlKey = "NFT_URL";
const String kNftFormatKey = "NFT_Format";
const String kSizeKey = "Size";
const String kDescriptionKey = "Description";
const String kCreatorKey = "Creator";
const String kAppTypeKey = "App_Type";
const String kWidthKey = "Width";
const String kHeightKey = "Height";
const String kQuantityKey = "Quantity";
const String kHashtagKey = "Hashtags";




const String kNoInternet = 'No internet';
const String kRecipeNotFound = 'Recipe not found';
const String kCookBookNotFound = 'Cookbook not found';

